module Api
  class V1::FollowersController < V1::BaseController
    def index
      ids = []
      current_user.followings.where.not(follower_id: current_user.blocks.pluck(:id)).each do |following|
        ids << following.follower.id if following.follower.blocks.include?(current_user)
      end
      blocked_ids = ids.flatten + current_user.blocks.pluck(:id)
      followers = current_user.followings.where.not(follower_id: blocked_ids).filter_on(filter_params)
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
