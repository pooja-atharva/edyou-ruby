module Api
  module V1
    class FollowSerializer < ActiveModel::Serializer
      attributes :id, :follower, :following

      def follower
        ActiveModelSerializers::SerializableResource.new(
          object.follower, serializer: Api::V1::UserSerializer
        )
      end

      def following
        ActiveModelSerializers::SerializableResource.new(
          object.followable, serializer: Api::V1::UserSerializer
        )
      end
    end
  end
end
