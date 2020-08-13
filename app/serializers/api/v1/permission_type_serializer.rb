module Api
  module V1
    class PermissionTypeSerializer < ActiveModel::Serializer
      attributes :id, :action_name, :action_description, :action
    end
  end
end
