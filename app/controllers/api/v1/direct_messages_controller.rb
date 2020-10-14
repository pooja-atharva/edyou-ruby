module Api
  class V1::DirectMessagesController < V1::ChatController

  def show
    user_ids = [current_user, User.find(params[:id])]
    @chatroom = Chatroom.direct_message_for_users(user_ids)
    # @messages = @chatroom.messages.order(created_at: :desc).limit(100).reverse
    @chatroom_user = current_user.chatroom_users.find_by(chatroom_id: @chatroom.id)
    @chatroom.user_ids.each do |user_id|
      ActionCable.server.broadcast "current_user_#{user_id}", {
        event_params: {
          sender_user_id: current_user.id,
          chatroom_id: @chatroom.id,
          user_id: user_id.to_i
        },
        data: {
          chatroom: JSON.parse(html(@chatroom, User.find(user_id)))
        },
        event: "chat_initiated"
      }
    end
  end

  def html(chatroom, current_user)
    ApplicationController.render(
      partial: 'api/v1/chatrooms/chatroom',
      locals: { chatroom: chatroom, current_user: current_user }
    )
  end

  end
end
