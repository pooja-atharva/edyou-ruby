json.partial! "api/v1/chatrooms/update_chatroom", chatroom: chatroom
json.group_member chatroom.joined_users.count
json.last_read_at chatroom.chatroom_users.find_by(user_id: current_user).try(:last_read_at)
if last_msg_read_at(current_user, chatroom).present? && (from_start.to_s.empty? || from_start.to_s == "false" )
  json.messages chatroom.messages.where('created_at > ?', last_msg_read_at(current_user, chatroom)).order(created_at: :desc).reverse do |message|
    json.partial! "api/v1/messages/message.json.jbuilder", message: message
  end
else
  json.messages chatroom.messages.order(created_at: :desc).reverse do |message|
    json.partial! "api/v1/messages/message.json.jbuilder", message: message
  end
end