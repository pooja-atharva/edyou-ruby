class MessageRelayJob < ApplicationJob
  queue_as :default

  def perform(message, event = 'created', user = '')
    if user.present?
      ActionCable.server.broadcast "current_user_#{user.id}", {
        data: JSON.parse(html(message)),
        event: event
      }
    else
      ActionCable.server.broadcast "chatrooms:#{message.chatroom.id}", {
        data: JSON.parse(html(message)),
        event: event
      }
    end
  end
  def html(message)
    ApplicationController.render(
      partial: 'api/v1/messages/message',
      locals: { message: message }
    )
  end
end
