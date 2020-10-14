json.chatroom do
  json.partial! "api/v1/chatrooms/update_chatroom", chatroom: chatroom
  json.users users do |user|
    json.extract! user, :id, :name
    json.is_admin user_admin_status(user, chatroom)
    json.profile_pic user.profile_pic_url
  end
end
