module Api
  module V1
    class PermissionSerializer < ActiveModel::Serializer
      attributes :id, :action_name, :action_description, :action_emoji,
                  :action, :action_object

    end
  end
end
