module Api
  class V1::PrivacySettingsController < V1::BaseController
    def index
      privacy_settings = current_user.privacy_settings
      data = {
        status: true, message: '',
        data: array_serializer.new(privacy_settings, serializer: Api::V1::PrivacySettingSerializer)
      }
      render json: data, status: default_status
    end

    def update
      render_unprocessable_entity('You have changes nothing in privacy setting.') and return if !params[:privacy_setting].present?
      params[:privacy_setting].each do |privacy_obj|
        privacy_setting = current_user.privacy_settings.find_by(action_object: privacy_obj[:action_object])
        if privacy_setting.present?
          privacy_setting.update(permission_type_id: privacy_obj[:permission_type_id], action_object: privacy_obj[:action_object])
        else
          current_user.privacy_settings.create(permission_type_id: privacy_obj[:permission_type_id], action_object: privacy_obj[:action_object])
        end
      end
      data = { status: true, message: 'Privacy Settings are updated successfully', data: nil}
      render json: data, status: default_status
    rescue ActiveRecord::RecordNotFound
      invalid_user_response
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