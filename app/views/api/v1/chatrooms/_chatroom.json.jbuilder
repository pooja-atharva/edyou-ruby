json.partial! "api/v1/chatrooms/update_chatroom", chatroom: chatroom
if current_user.present?
	json.unread_count unread_count(current_user, chatroom)
end
if chatroom.direct_message
	if chatroom.other_user(current_user).present?
	  json.user do
	    json.extract! chatroom.other_user(current_user), :id, :name
	    json.profile_pic chatroom.other_user(current_user).profile_pic_url
	  end
	else
	  json.user Hash.new
	end
else
	json.users chatroom.joined_users do |user|
	  json.extract! user, :id, :name
	  json.is_admin user_admin_status(user, chatroom)
	  json.profile_pic user.profile_pic_url
	end
end
json.group_member chatroom.joined_users.count
if current_user.present?
	json.last_read_at chatroom.chatroom_users.where(user_id: current_user).try(:last).try(:last_read_at)
end
if chatroom.last_msg.present?
	json.message do
		json.partial! "api/v1/messages/message.json.jbuilder", message: chatroom.last_msg
	end
else
	json.message Hash.new
end
