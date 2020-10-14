json.success true
json.error ""
json.data do
  json.chatrooms do |chatroomsElement|
    chatroomsElement.array! @chatrooms do |chatroom|
      json.extract! chatroom, :id, :name, :direct_message, :user_ids, :created_at, :updated_at, :last_message
      json.deleted chatroom&.discarded?
      if chatroom.other_user(@current_user).present?
        json.user do
          json.extract! chatroom.other_user(@current_user), :id, :email, :user_id, :created_at, :updated_at
          if @user_data.present? && @user_data["users"].present?
            @user_data["users"].each do|data|
              if data[0]== chatroom.other_user(@current_user).id
                json.merge! data[1]
              end
            end
          end
        end
      else
        json.user Hash.new
      end
      json.group_member chatroom.joined_users.count
      json.last_read_at chatroom.chatroom_users.where(user_id: @current_user.id).try(:last).try(:last_read_at)
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
