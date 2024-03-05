class MessagesController < ApplicationController
  before_action :authenticate_user!
  def create
    if Entry.where(user_id: current_user.id, room_id: params[:message][:room_id]).present?
      # form_withで送られてきたuser_idがcurrent_user.idで、room_idが params[:message]のroom_idであるEntryが存在するなら
      @message = Message.new(message_params)
      @message.user_id = current_user.id
      @message.save
    else
      flash[:alert] = "メッセージ送信に失敗しました。"
    end
    render :validater unless @message.save
  end

  private
  def message_params
    params.require(:message).permit(:user_id, :room_id, :content)
  end
end