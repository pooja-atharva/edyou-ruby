module Api
  class V1::PostSettingsController < V1::BaseController
    def index
      render_success_response( { post_settings: post_settings_data })
    end

    def update
      render_unprocessable_entity('You have changes nothing in post setting.') and return unless params[:post_setting].present?
      params[:post_setting].each do |post_obj|
        post_setting = current_user.post_settings.find_or_initialize_by(remove_datetime: post_obj[:remove_datetime])
        post_setting.save
      end
      render_success_response( { post_settings: post_settings_data}, 'Post Settings are updated successfully' )
    end

    private
    def post_setting_params
      params.require(:post_setting).permit(:remove_datetime)
    end

    def post_setting_data(object)
      single_serializer.new(object, serializer: Api::V1::PostSettingSerializer)
    end

    def post_settings_data
      array_serializer.new(current_user.post_settings, serializer: Api::V1::PostSettingSerializer)
    end
  end
end
