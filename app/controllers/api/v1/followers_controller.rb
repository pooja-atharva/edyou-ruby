module Api
  class V1::FollowersController < V1::BaseController
    def index
      followers = current_user.followings.filter_on(filter_params)
      render_success_response(
        { followers: array_serializer.new(followers, serializer: Api::V1::FollowSerializer) },
        '',  200, page_meta(followers, filter_params)
      )
    end

    private

    def filter_params
      params.permit(:page, :per)
    end
  end
end
