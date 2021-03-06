module Api
  module V1
    class FriendshipSerializer < ActiveModel::Serializer
      attributes :id, :user, :friend, :status

      def status
        object.show_status(@instance_options[:current_user])
      end

      def user
        ActiveModelSerializers::SerializableResource.new(object.user, serializer: Api::V1::UserSerializer)
      end

      def friend
        ActiveModelSerializers::SerializableResource.new(object.friend, serializer: Api::V1::UserSerializer)
      end
    end
  end
end
