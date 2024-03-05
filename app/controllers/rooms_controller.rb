class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_non_related, only: [:show]
  
  def create
    @room = Room.create
    # チャット開始ボタンが押された後、新しいRoomモデルのインスタンスを作成
    @entry1 = Entry.create(room_id: @room.id, user_id: current_user.id)
    # current_userのuser_idとroom_idを記録
    # Entryモデルのroom_idに@roomで作成したRoomモデルのidをセット、Entryモデルのuser_idに現在のユーザーのidをセット
    @entry2 = Entry.create(params.require(:entry).permit(:user_id, :room_id).merge(room_id: @room.id))
    # 詳細ページのユーザーのuser_idとroom_idを記録
    # 詳細ページのユーザーのuser_idとroom_idをparamsで取得し、
    # 共通のRoomなので@roomで取得したRoomモデルのidをroom_idにmergeで追加
    redirect_to "/rooms/#{@room.id}"
    # createで新しく作成されたRoomのページにリダイレクト
  end
  
  def show
    @room = Room.find(params[:id])
    # １つのチャットルームを表示させるためにfindメソッドで取得
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
      # Entriesテーブルに、現在ログインしているユーザーのidとそれにひもづいたチャットルームのidを探し、そのレコードがあるか確認
      @messages = @room.messages
      # Messageテーブルにそのチャットルームのidと紐づいたメッセージを表示させる
      @message = Message.new
      # 新しくメッセージを作成する場合はメッセージのインスタンスを生成する
      @entries = @room.entries
      # ビューページにユーザーの名前などの情報を表示させるために用意
    else
      redirect_back fallback_location: root_path
      # 直前のページにリダイレクト、fallback_locationで直前のページに戻れなかった際のパスも指定
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
  # 相互フォローでないユーザーが直接チャットルームのURLを検索しても、チャットルームに入れないようにする
end
