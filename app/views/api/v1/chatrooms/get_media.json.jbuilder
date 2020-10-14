json.success true
json.error ""
json.data do
	json.messages @chatroom_media do |message|
      if message.file.attached?
        json.partial! "api/v1/messages/message.json.jbuilder", message: message
      end
    end
end
json.total_count @total_count
json.last_page @chatroom_media.last_page?