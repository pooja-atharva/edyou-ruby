module Api
  class V1::PrivacySettingsController < V1::BaseController
    def index
      render_success_response(
        { privacy_settings: array_serializer.new(current_user.privacy_settings, serializer: Api::V1::PrivacySettingSerializer) }
      )
    end

    def update
      render_unprocessable_entity('You have changes nothing in privacy setting.') and return unless params[:privacy_setting].present?
      params[:privacy_setting].each do |privacy_obj|
        privacy_setting = current_user.privacy_settings.find_or_initialize_by(action_object: privacy_obj[:action_object])
        privacy_setting.permission_type_id = privacy_obj[:permission_type_id]
        privacy_setting.action_object = privacy_obj[:action_object]
        privacy_setting.save
      end
      render_success_response(
        { privacy_settings: array_serializer.new(current_user.privacy_settings, serializer: Api::V1::PrivacySettingSerializer) },
        'Privacy Settings are updated successfully'
      )
    end

    private
    def privacy_setting_params
      params.require(:privacy_setting).permit(:user_id, :permission_type_id, :action_object)
    end

    def privacy_setting_data(object)
      single_serializer.new(object, serializer: Api::V1::PrivacySettingSerializer)
    end
  end
end