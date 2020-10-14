json.chatrooms do |chatroomsElement|
	chatroomsElement.array! chatrooms do |chatroom|
	  json.partial! "api/v1/chatrooms/chatroom.json.jbuilder", chatroom: chatroom, current_user: current_user
	  json.unread_count unread_count(current_user, chatroom)
	end
end
