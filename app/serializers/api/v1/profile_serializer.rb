
module Api
  module V1
    class ProfileSerializer < ActiveModel::Serializer
      attributes :id, :email, :class_name, :graduation, :major, :status, :attending_university,
      :high_school, :from_location, :gender, :religion, :language, :date_of_birth, :favourite_quotes,

      def email
        object.user.email
      end
    end
  end
end
