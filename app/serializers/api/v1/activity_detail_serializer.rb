module Api
  module V1
    class ActivityDetailSerializer < ActiveModel::Serializer
      attributes :id, :name, :parent, :sub_activities

      def parent
        unless object.parent_id.blank?
          object.parent_activity.name
        else
          ''
        end
      end

      def sub_activities
        ActiveModel::Serializer::CollectionSerializer.new(object.sub_activities, serializer: Api::V1::SubActivitySerializer)
      end
    end
  end
end
