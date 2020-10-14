class MessageChannel < ApplicationCable::Channel
  def subscribed
  end

  def unsubscribed
  end

  def find_message(data)
  	if data["message_id"].present?
  		message = Message.find(data["message_id"])
  		MessageRelayJob.perform_later(message, 'fetch_message',current_user)
  	end
  end
end
