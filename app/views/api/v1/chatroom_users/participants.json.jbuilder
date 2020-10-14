json.success true
json.error ""
json.data do
  json.chatroom do
    json.partial! "api/v1/chatrooms/update_chatroom", chatroom: @chatroom
    json.group_member @chatroom.joined_users.count
    json.users @chatroom.joined_users do |user|
      json.extract! user, :id, :name
      json.is_admin user_admin_status(user, @chatroom)
      json.profile_pic user.profile_pic_url
    end
  end
end
