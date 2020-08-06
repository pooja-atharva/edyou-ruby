module Api
  class V1::FollowersController < V1::BaseController
    skip_before_action :doorkeeper_authorize!, except: %i[index create delete]
    before_action :set_user, only: [:create, :destroy]

    def index
      follows = current_user.all_follows.filter_on(filter_params)
      render_success_response({
        follows: array_serializer.new(follows, serializer: Api::V1::FollowSerializer)
      }, page_meta(follows))
    end

    def create
      if current_user == @user
        render_unprocessable_entity("You cannot follow yourself")
      else
        if current_user.following?(@user)
          follow = Follow.where(follower_id: current_user.id, followable_id: @user.id).first
          message = 'You already following this user'
        else
          follow = current_user.follow(@user)
          message = 'You are now following this user'
        end
        data = {
          status: true, message: message,
          data: single_serializer.new(follow, serializer: Api::V1::FollowSerializer)  
        }
        render json: data, status: default_status
      end
    end

    def destroy
      follow = current_user.stop_following(user)
      data = {
        status: true, message: 'You are no longer following this user',
        data: single_serializer.new(follow, serializer: Api::V1::FollowSerializer)  
      } 
      render json: data, status: default_status
    end

    private

    def filter_params
      params.permit(:page, :per)
    end

    def set_user
      @user = User.find(params[:user_id])
    end
  end
end
  