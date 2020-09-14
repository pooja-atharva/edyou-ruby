
module Api
  module V1
    class ProfileSerializer < ActiveModel::Serializer
      attributes :id, :user_id, :email, :class_name, :graduation, :major, :status, :attending_university,
      :high_school, :from_location, :gender, :religion, :language, :date_of_birth, :favourite_quotes,

      def email
        object.user.try(:email)
      end
    end
  end
end
