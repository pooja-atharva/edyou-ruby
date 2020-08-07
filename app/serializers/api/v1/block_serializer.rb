module Api
  module V1
    class BlockSerializer < ActiveModel::Serializer
      attributes :id, :type, :blocker
      
      def type
        object.follower_type
      end
      
      def blocker
        byebug
        blocked_entity = object.follower_type.constantize.find_by_id(object.follower_id)
        ActiveModelSerializers::SerializableResource.new(
          blocked_entity,
          serializer: "Api::V1::#{object.follower_type}Serializer".constantize
        )
      end
    end
  end
end
