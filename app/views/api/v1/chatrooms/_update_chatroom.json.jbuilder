json.extract! chatroom, :id, :name, :direct_message, :created_at, :updated_at, :last_message, :description
json.group_image chatroom.group_image.attached? ? chatroom.group_image.service_url(expires_in: Rails.application.config.active_storage.service_urls_expire_in) : ""
json.created_by chatroom&.created_by&.name
json.deleted chatroom&.discarded?
