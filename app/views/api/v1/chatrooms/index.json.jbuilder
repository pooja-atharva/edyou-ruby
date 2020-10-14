json.success true
json.error ""
json.data do
  json.chatrooms do |chatroomsElement|
    chatroomsElement.array! @chatrooms do |chatroom|
      json.partial! "api/v1/chatrooms/update_chatroom", chatroom: chatroom
      json.unread_count unread_count(current_user, chatroom)
      if chatroom.direct_message
        if chatroom.other_user(current_user).present?
          json.user do
            json.extract! chatroom.other_user(current_user), :id, :created_at, :updated_at
            json.profile_pic chatroom.other_user(current_user).profile_pic_url
          end
        else
          json.user Hash.new
        end
      else
        json.users chatroom.joined_users do |user|
          json.extract! user, :id, :created_at, :updated_at
          json.is_admin user_admin_status(user, chatroom)
          json.profile_pic user.profile_pic_url
        end
      end
      if chatroom.last_msg.present?
        json.message do
          json.partial! "api/v1/messages/message.json.jbuilder", message: chatroom.last_msg
        end
      else
        json.message Hash.new
      end
    end
  end
end
json.meta do
  json.pagination do
    json.partial! "api/v1/meta/meta.json.jbuilder", collection: @chatrooms
  end
end
