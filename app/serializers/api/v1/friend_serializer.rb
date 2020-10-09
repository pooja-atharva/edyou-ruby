module Api
  module V1
    class FriendSerializer < ActiveModel::Serializer
      attributes :user

      def user
        ActiveModelSerializers::SerializableResource.new(object, serializer: Api::V1::UserSerializer)
      end
    end
  end
end
