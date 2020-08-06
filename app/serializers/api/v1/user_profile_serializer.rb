class UserProfileSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :batch, :graduation, :major, :marital_status, :attending, 
             :high_school, :address, :gender, :religion, :language, :birthdate
end
