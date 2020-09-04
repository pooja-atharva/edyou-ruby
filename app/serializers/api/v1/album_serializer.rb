module Api
  module V1
    class AlbumSerializer < ActiveModel::Serializer
      attributes :id, :name, :description, :user, :permission,
                  :access_requirement_ids, :allow_contributors,
                  :contributors, :posts_count

      def contributors
        ActiveModelSerializers::SerializableResource.new(object.contributing_users, each_serializer: Api::V1::UserSerializer)
      end

      def user
        ActiveModelSerializers::SerializableResource.new(object.user, serializer: Api::V1::UserSerializer)
      end

      def permission
        ActiveModelSerializers::SerializableResource.new(object.permission, serializer: Api::V1::PermissionSerializer)
      end
    end
  end
end
