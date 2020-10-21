expires_in = Rails.application.config.active_storage.service_urls_expire_in.to_i
expires_at = Time.current + expires_in.seconds

json.id message.id
json.body message.body
json.chatroom_id message.chatroom_id
json.discarded_at message.discarded_at
json.user_id message.user_id
json.created_at message.created_at
json.updated_at message.updated_at
json.user do
  json.extract! message.user, :id, :name
  json.profile_pic message.user.profile_pic_url
end
if message.file.attached?
	json.attachment do
	  json.url message.file.service_url(expires_in: Rails.application.config.active_storage.service_urls_expire_in)
      json.thumbnail msg_thumb_url(message)
      json.expires_in expires_in
  	  json.expires_at expires_at
	  json.media_type message.media_type
	  json.mime_type message.file.content_type.present? ? message.file.content_type : ''
	  json.file_name message.file.filename.to_s
	end
else
	json.attachment Hash.new
end
