class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_non_related, only: [:show]
  
  def create
    @room = Room.create
    # 新しいRoomモデルのインスタンスを作成
    @entry1 = Entry.create(room_id: @room.id, user_id: current_user.id)
    # Entryモデルのroom_idに@roomで作成したRoomモデルのidをセット、Entryモデルのuser_idに現在のユーザーのidをセット
    @entry2 = Entry.create(params.require(:entry).permit(:user_id, :room_id).merge(room_id: @room.id))
    # Entryモデルのuser_idとroom_idをparamsで取得し、@roomで取得したRoomモデルのidをroom_idにmergeで追加
    redirect_to "/rooms/#{@room.id}"
    # createで新しく作成されたRoomのページにリダイレクト
  end
  
  def show
    @room = Room.find(params[:id])
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
      @messages = @room.messages
      @message = Message.new
      @entries = @room.entries
    else
      redirect_back(fallback_location: root_path)
    end
  end
  
  private
  def reject_non_related
    room = Room.find(params[:id])
    user = room.entries.where.not(user_id: current_user.id).first.user
    unless (current_user.following?(user)) && (user.following?(current_user))
      redirect_to books_path
    end
  end
end
