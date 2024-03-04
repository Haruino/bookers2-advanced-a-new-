class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @currentUserEntry = Entry.where(user_id: current_user.id)
    # entriesテーブルのuser_idカラムから現在ログインしているユーザーの全Entryデータを取得
    @userEntry = Entry.where(user_id: @user.id)
    # entriesテーブルのuser_idカラムから@userの全Entryデータを取得。
    unless @user.id == current_user.id
      # @user と current_user が別人の時
      @currentUserEntry.each do |cu| 
        # 現在ログインしているユーザーの全Entryデータを1つずつ取り出して、変数cuに代入
        @userEntry.each do |u| 
          # @userの全Entryデータを1つずつ取り出して、変数uに代入
          if cu.room_id == u.room_id 
            # もし現在ログインしているユーザーのEntryデータのうち、room_idが@userのEntryデータの持つroom_idと同じなら
            @isRoom = true
            # 現在ログインしているユーザーと@userの共通のRoomがあることを明確に
            @roomId = cu.room_id
            # そして@roomIdにその現在ログインしているユーザーと@userの共通のroom_id(entriesテーブル)を代入
          end
        end
      end
      
      unless @isRoom
        # 現在ログインしているユーザーと@userの共通のRoomがない時
        @room = Room.new
        @entry = Entry.new
        # 新しい Roomと Entryを作成
      end
    end
    @books = @user.books
    @book = Book.new
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
