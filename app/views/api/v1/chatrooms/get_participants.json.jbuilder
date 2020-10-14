json.success true
json.error ""
json.data do
	json.users @chatroom_users do |user|
        json.extract! user, :id, :name
        json.profile_pic user.profile_pic_url
        json.is_admin user_admin_status(user, @chatroom)
    end
end
json.meta do
	json.pagination do
	  json.partial! "api/v1/meta/meta.json.jbuilder", collection: @chatroom_users
	end
end
