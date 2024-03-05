class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @currentUserEntry = Entry.where(user_id: current_user.id)
    # entriesテーブルの中に記録されている現在ログインしているユーザーのuser_idが含まれているレコードを取得
    @userEntry = Entry.where(user_id: @user.id)
    # entriesテーブルの中に記録されている@userで取得したユーザーのuser_idが含まれているレコードを取得
    unless @user.id == current_user.id
      # @user と current_user が別人の時
      @currentUserEntry.each do |cu| 
        # 現在ログインしているユーザーの全Entryデータを1つずつ取り出して、変数cuに代入
        @userEntry.each do |u| 
          # @userの全Entryデータを1つずつ取り出して、変数uに代入
          if cu.room_id == u.room_id 
            # もし現在ログインしているユーザーのEntryデータのroom_idが@userのEntryデータの持つroom_idと同じなら
            @isRoom = true
            # 現在ログインしているユーザーと@userの共通のRoomがあることを明確に
            # DMのルームが未作成の場合の処理を後に実行するので必要
            @roomId = cu.room_id
            # そして@roomIdにその現在ログインしているユーザーと@userの共通のroom_id(entriesテーブル)を代入
            # DMのルームに行くリンクのパスを設定するために記述
          end
        end
      end
      
      if @isRoom != true
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
