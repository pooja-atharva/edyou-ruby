module Api
  module V1
    class PostSerializer < ActiveModel::Serializer
      attributes :id, :body, :publish_date, :parent_id, :parent_type,
          :comment_count, :like_count, :user, :tagged_users

      def tagged_users
        ActiveModelSerializers::SerializableResource.new(object.tagged_users, each_serializer: Api::V1::TaggedUserSerializer)
      end

      def user
        ActiveModelSerializers::SerializableResource.new(object.user, serializer: Api::V1::UserSerializer)
      end
    end
  end
end
