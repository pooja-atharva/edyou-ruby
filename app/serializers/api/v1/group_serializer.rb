module Api
  module V1
    class GroupSerializer < ActiveModel::Serializer
      attributes :id, :name, :owner, :group_users, :privacy, :university, :section, :president, :vice_president, :treasure,
         :social_director, :secretary, :email, :calendar_link, :status, :users_count

      def owner
        ActiveModelSerializers::SerializableResource.new(object.owner, serializer: Api::V1::UserSerializer)
      end

      def group_users
        ActiveModel::Serializer::CollectionSerializer.new(object.groups_users, serializer: Api::V1::GroupsUserSerializer)
      end
    end
  end
end
