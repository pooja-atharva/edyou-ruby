json.success true
json.error ""
json.data do
	json.users do |usersElement|
		usersElement.array! @users do |user|
			json.extract! user, :id, :name
      		json.profile_pic user.profile_pic_url
		end
	end
end
json.meta do
  json.pagination do
    json.partial! "api/v1/meta/meta.json.jbuilder", collection: @users
  end
end
