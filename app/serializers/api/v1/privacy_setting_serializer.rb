module Api
  module V1
    class PrivacySettingSerializer < ActiveModel::Serializer
      attributes :id, :action_object
      belongs_to :permission_type, serializer: Api::V1::PermissionTypeSerializer
      belongs_to :user, serializer: Api::V1::UserSerializer
    end
  end
end
 