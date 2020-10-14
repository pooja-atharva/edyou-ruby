class LastReadChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def get_messages(data)
    chatroom_user = current_user.chatroom_users.find_by(chatroom_id: data["chatroom_id"])
    if chatroom_user.present?
      chatroom = chatroom_user.chatroom
      BulkMessageJob.perform_later(chatroom, current_user, data["from_start"])
    end
  end

  def update_timestamp(data)
    chatroom_user =
      current_user.chatroom_users.find_by(chatroom_id: data['chatroom_id'])
    if chatroom_user.present?
      message = Message.find(data['message_id'])
      chatroom_user.update_columns(
        last_read_at: message.created_at,
        message_id: message.id
      )
      ActionCable.server.broadcast "current_user_#{current_user.id}", {
        event_params: {
          success: 'Timestamp updated successfully',
          last_read_at: chatroom_user.last_read_at,
          chatroom_id: chatroom_user.chatroom_id
        },
        event: "updated_timestamp"
      }
    end
  end
end
