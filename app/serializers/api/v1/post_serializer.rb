module Api
  module V1
    class PostSerializer < ActiveModel::Serializer
      attributes :id, :body, :publish_date, :parent, :feeling, :activity, :comment_count, :like_count, :post_reports_count, :permission,
                 :access_requirement_ids, :user, :tagged_users, :status, :delete_post_after_24_hour, :groups, :location, :is_liked

      def is_liked
        total_likes = object.likes.where(user_id: scope.id).count
        if total_likes > 0
          true
        else
          false
        end
      end

      def feeling
        object.feeling_id.present? ? object.feeling.name : ''
      end

      def activity
        return '' if object.activity_id.nil?
        [object.post_activity.parent_activity.try(:name).try(:downcase), object.post_activity.name].compact.join(' ')
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

      def location
        unless object.location.blank?
          ActiveModelSerializers::SerializableResource.new(object.location, serializer: Api::V1::LocationSerializer)
        end
      end

      def permission
        ActiveModelSerializers::SerializableResource.new(object.permission, serializer: Api::V1::PermissionSerializer)
      end

      def groups
        unless object.groups.blank?
          ActiveModelSerializers::SerializableResource.new(object.groups, serializer: Api::V1::GroupSerializer)
        end
      end
    end
  end
end
