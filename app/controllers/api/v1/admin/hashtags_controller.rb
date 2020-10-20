module Api
  class V1::Admin::HashtagsController < V1::BaseController

    def create
      hashtag = Tagging.new(context: hashtag_params[:context])
      if hashtag.save
        hashtag_stat = HashtagStat.find_or_create_by(context: hashtag.context)
        hashtag_stat.update_column(:high_priority, true)
        render_success_response({
          hashtag: single_serializer.new(hashtag, serializer: Api::V1::HashtagStatSerializer)
          }, "hashtag created successfully.")
      else
        render_unprocessable_entity(hashtag.errors.full_messages.join(','))
      end
    end

    private
    def hashtag_params
      params.require(:hashtag).permit(:taggable_type, :context)
    end
  end
end
