module Api
  module V1
    class UserSerializer < ActiveModel::Serializer
      attributes :id, :email, :name, :profile_image

      def profile_image
        # object.profile_image.service_url.sub(/\?.*/, '') if object.profile_image.attached?
      end
    end
  end
end
