json.chatroom do
  json.partial! "api/v1/chatrooms/update_chatroom", chatroom: chatroom
  json.user do
    json.extract! user, :id, :name
    if !event.present?
    	json.is_admin user_admin_status(user, chatroom)
    end
    json.profile_pic user.profile_pic_url
  end
end
