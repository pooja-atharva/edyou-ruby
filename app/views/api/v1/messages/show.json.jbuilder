json.success true
json.error ""
json.data do
	json.message do
	  json.partial! "api/v1/messages/message.json.jbuilder", message: @message
	end
end
