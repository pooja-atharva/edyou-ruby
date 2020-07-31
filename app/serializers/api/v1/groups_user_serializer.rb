module Api
  module V1
    class GroupsUserSerializer < ActiveModel::Serializer
      attributes :id, :admin, :user

      def user
        ActiveModelSerializers::SerializableResource.new(object.user, serializer: Api::V1::UserSerializer)
      end
    end
  end
end
