module Api
  class V1::FollowingsController < V1::BaseController

    def index
      follows = current_user.all_follows.filter_on(filter_params)
      render_success_response(
        { follows: array_serializer.new(follows, serializer: Api::V1::FollowSerializer) },
        '',  200, page_meta(follows, filter_params)
      )
    end

    def create
      user = User.find_by_id(params[:user_id])
      render_unprocessable_entity('User is not found') and return if user.nil?
      render_unprocessable_entity('You cannot follow yourself') and return if current_user == user
      if current_user.following?(user)
        follow = Follow.where(follower_id: current_user.id, followable_id: user.id).first
        message = 'You already following this user'
      else
        follow = current_user.follow(user)
        message = 'You are now following this user'
      end
      data = {
        status: true, message: message,
        data: single_serializer.new(follow, serializer: Api::V1::FollowSerializer)
      }
      render json: data, status: default_status
    end

    def destroy
      user = User.find_by_id(params[:id])
      render_unprocessable_entity('User is not found') and return if user.nil?
      render_unprocessable_entity('You cannot unfollow yourself') and return if current_user == user
      if current_user.stop_following(user)
        data = {
          status: true, message: 'You are no longer following this user',
          data: nil
        }
        render json: data, status: default_status
      else
        render_unprocessable_entity('You are not following to this user.')
      end
    end

    private

    def filter_params
      params.permit(:page, :per)
    end
  end
end