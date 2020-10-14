json.success true
json.error ""
json.data do
  json.chatroom do
    json.partial! "api/v1/chatrooms/update_chatroom", chatroom: @chatroom
    json.group_member @chatroom.joined_users.count
    if @chatroom.direct_message
      if @chatroom.other_user(current_user).present?
        json.user do
          json.extract! @chatroom.other_user(current_user), :id, :name
          json.profile_pic @chatroom.other_user(current_user).profile_pic_url
        end
      else
        json.user Hash.new
      end
    else
      json.users @chatroom_users do |user|
        json.extract! user, :id, :name
        json.profile_pic user.profile_pic_url
        json.is_admin user_admin_status(user, @chatroom)
      end
      json.meta do
        json.user_pagination do
          json.partial! "api/v1/meta/meta.json.jbuilder", collection: @chatroom_users
        end
      end
    end
    json.messages @chatroom_media do |message|
      if message.file.attached?
        json.partial! "api/v1/messages/message.json.jbuilder", message: message
      end
    end
    json.meta do
      json.message_pagination do
        json.partial! "api/v1/meta/meta.json.jbuilder", collection: @chatroom_media
      end
    end
  end
end
