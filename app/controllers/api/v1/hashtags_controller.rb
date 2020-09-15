module Api
  class V1::HashtagsController < V1::BaseController
    def index
      render_unprocessable_entity('Query params must be present.') and return unless search_params[:query].present?
      hashtags = Hashtag.all.where("context LIKE ?",  "#{search_params[:query]}%").order(count: :desc).filter_on(filter_params)
      if hashtags.present?
        render_success_response(
          { hashtags: array_serializer.new(hashtags, serializer: Api::V1::HashtagSerializer) },
          '',  200, page_meta(hashtags, filter_params)
        )
      else
        render_success_response(nil, 'No hashtag found.')
      end
    end

    private
    def search_params
      params.permit(:query)
    end

    def filter_params
      params.permit(:page, :per)
    end
  end
end