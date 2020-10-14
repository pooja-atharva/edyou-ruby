module Api
  module V1
    class UserSerializer < ActiveModel::Serializer
      attributes :id, :email, :name, :profile_image
      attribute :blocked, if: :admin_user?

      def profile_image
        object.profile_pic_url
      end

      def admin_user?
        @instance_options[:current_user] && @instance_options[:current_user].admin? rescue false
      end
    end
  end
end
