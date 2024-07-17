class Public::MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @message = current_user.messages.build(message_params)
    if @message.save
      create_notification(@message)
      redirect_to room_path(@message.room)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def message_params
    params.require(:message).permit(:room_id, :message)
  end

  def create_notification(message)
    room = message.room
    recipient_entry = room.entries.where.not(user_id: message.user_id).first
    if recipient_entry
      recipient = recipient_entry.user
      Notification.create(user: recipient, message: message)
    else
      Rails.logger.debug "No recipient found for notification"
    end
  end
end

