module Api
  module V1
    class PostSerializer < ActiveModel::Serializer
      attributes :id, :body, :publish_date, :parent,
          :feeling, :activity, :comment_count, :like_count, :permission,
          :access_requirement_ids, :user, :tagged_users, :status,
          :delete_post_after_24_hour

      def feeling
        unless object.feeling_id.blank?
          object.feeling.name
        else
          ""
        end
      end

      def activity
        unless  object.activity_id.blank?
          "#{object.activity.parent_activity.name.downcase} #{object.activity.name}"
        else
          ""
        end
      end

      def parent
        if object.parent_type == 'Album'
          ActiveModelSerializers::SerializableResource.new(object.parent, each_serializer: Api::V1::AlbumSerializer)
        end
      end

      def tagged_users
        ActiveModelSerializers::SerializableResource.new(object.tagged_users, each_serializer: Api::V1::TaggedUserSerializer)
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
