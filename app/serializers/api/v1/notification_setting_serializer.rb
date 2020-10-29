module Api
  module V1
    class NotificationSettingSerializer < ActiveModel::Serializer
      attributes :notification_type, :notify
    end
  end
end
