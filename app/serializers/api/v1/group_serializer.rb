module Api
  module V1
    class GroupSerializer < ActiveModel::Serializer
      include Rails.application.routes.url_helpers
      attributes :id, :name, :description, :privacy, :university, :section,
                 :president, :vice_president, :treasure, :social_director,
                 :secretary, :email, :calendar_link, :status, :users_count,
                 :avatar, :friends_count, :owner, :group_users

      def owner
        ActiveModelSerializers::SerializableResource.new(object.owner, serializer: Api::V1::UserSerializer)
      end

      def group_users
        ActiveModel::Serializer::CollectionSerializer.new(object.groups_users, serializer: Api::V1::GroupsUserSerializer)
      end

      def avatar
        object.avatar.attached? ? rails_blob_url(object.avatar) : nil
      end

      def friends_count
        current_user = @instance_options[:current_user]
        if current_user.present?
          object.groups_users
            .joins("INNER JOIN friendships on (friendships.friend_id = groups_users.user_id) OR (friendships.user_id = groups_users.user_id) AND (friendships.friend_id != #{current_user.id} AND friendships.user_id != #{current_user.id})")
            .where(friendships: {status: '1'}).count
        else
          0
        end
      end
    end
  end
end
