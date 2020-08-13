module Api
  module V1
    class PermissionSerializer < ActiveModel::Serializer
      attributes :id, :action_object, :action_emoji
      belongs_to :permission_type, serializer: Api::V1::PermissionTypeSerializer
    end
  end
end
