json.success true
json.error ""
json.data do
	json.user do
	  json.id @user.id
	  json.user_id @user.user_id
	  json.email @user.email
	  json.created_at @user.created_at
	  json.updated_at @user.updated_at
	end
end
