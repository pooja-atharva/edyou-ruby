json.success true
json.error ""
json.data do
	json.chatroom do
	  json.partial! "api/v1/chatrooms/update_chatroom", chatroom: @chatroom
	  json.unread_count unread_count(current_user, @chatroom)
	end
end