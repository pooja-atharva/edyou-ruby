module Api
  class V1::StorySettingsController < V1::BaseController
    def index
      story_setting = StorySetting.find_or_create_by(user_id: current_user.id)
      render_success_response({ story_settings: story_setting_data(story_setting) })
    end

    def update
      render_unprocessable_entity('You have changes nothing in story setting.') and return unless params[:story_setting].present?
      story_setting = StorySetting.find_or_create_by(user_id: current_user.id)
      if story_setting.update_attributes(story_setting_params)
        render_success_response({ story_settings: story_setting_data(current_user.story_setting)}, 'Story Settings are updated successfully' )
      else
        render_unprocessable_entity(story_setting.errors.full_messages.join(','))
      end
    end

    private
    def story_setting_params
      params.require(:story_setting).permit(:share_public_story, :share_mentioned_story)
    end

    def story_setting_data(object)
      single_serializer.new(object, serializer: Api::V1::StorySettingSerializer)
    end
  end
end
