json.success true
json.error ""
json.data do
	if @chatroom.messages.exists?
	    json.messages @chatroom_messages.reverse do |message|
	      json.partial! "api/v1/messages/message.json.jbuilder", message: message
	    end
	else
	  json.messages Hash.new
	end
end
json.last_page @chatroom_messages.last_page?
