module Api
  module V1
    class ActivitySerializer < ActiveModel::Serializer
      attributes :id, :name, :parent

      def parent
        unless object.parent_id.blank?
          object.parent_activity.name
        else
          ""
        end
      end
    end
  end
end
