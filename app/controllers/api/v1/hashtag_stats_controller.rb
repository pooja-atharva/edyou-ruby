module Api
  class V1::HashtagStatsController < V1::BaseController
    def index
      render_unprocessable_entity('Query params must be present.') and return unless search_params[:query].present?
      hashtag_stats = HashtagStat.all.where("context LIKE ?",  "#{search_params[:query]}%").order(count: :desc).filter_on(filter_params)
      if hashtag_stats.present?
        render_success_response(
          { hashtag_stats: array_serializer.new(hashtag_stats, serializer: Api::V1::HashtagStatSerializer) },
          '',  200, page_meta(hashtag_stats, filter_params)
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