json.success true
json.error ""
json.data do
	json.chatroom do
	  json.partial! "api/v1/chatrooms/update_chatroom", chatroom: @chatroom_user.chatroom
	  json.user do
	    json.extract! @chatroom_user.user, :id, :name
	    json.is_admin @chatroom_user.is_admin
	    json.profile_pic @chatroom_user.user.profile_pic_url
	  end
	end
end
