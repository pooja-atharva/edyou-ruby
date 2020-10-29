module Api
  class V1::NotificationSettingsController < V1::BaseController
    def index
      render_success_response({
        notification_settings: notification_settings(current_user.notification_settings)
      })
    end

    def update
      notification_setting = current_user.notification_settings.find_by(notification_type: notification_setting_params[:notification_type])
      render_unprocessable_entity('Notification setting is not found') and return if notification_setting.blank?
      if notification_setting.update_attributes(notification_setting_params)
        render_success_response({
          notification_settings: notification_settings(current_user.notification_settings)
        }, 'notification Settings are updated successfully')
      else
        render_unprocessable_entity(notification_setting.errors.full_messages.join(','))
      end
    end

    private
    def notification_setting_params
      params.permit(:notification_type, :notify)
    end

    def notification_settings(object)
      array_serializer.new(object, serializer: Api::V1::NotificationSettingSerializer)
    end
  end
end