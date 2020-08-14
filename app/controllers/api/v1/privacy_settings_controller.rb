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
      privacy_setting = current_user.privacy_settings.find_by(id: params[:id])
      render json: {status: false, message: 'Privacy Setting is not found.'}, status: 404 and return if privacy_setting.nil?
      privacy_setting.attributes = privacy_setting_params
      if privacy_setting.save
        data = { status: true, message: 'Privacy Setting is updated successfully', data: privacy_setting_data(privacy_setting)}
      end
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