class BulkMessageJob < ApplicationJob
	def perform(chatroom, current_user, from_start)
    ActionCable.server.broadcast "current_user_#{current_user.id}", {
      data: {
      	chatroom: JSON.parse(html(chatroom,current_user, from_start))
      }
    }
  end
  def html(chatroom,current_user, from_start)
    ApplicationController.render(
      partial: 'api/v1/chatrooms/chatroom_messages',
      locals: { chatroom: chatroom, current_user: current_user, from_start: from_start }
    )
  end
end
