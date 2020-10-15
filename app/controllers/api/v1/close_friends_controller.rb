module Api
  class V1::CloseFriendsController < V1::BaseController
    def index
      close_friends = current_user.close_friends
      data = {
        status: true, message: '',
        data: array_serializer.new(close_friends, serializer: Api::V1::FriendSerializer)
      }
      render json: data, status: default_status
    end

    def create
      close_friendship = current_user.close_friendships.new(close_friend_params)
      close_friendship.relavance = "close_friend"
      if close_friendship.save
        data = { status: true, message: 'Close friend is added successfully', data: close_friend_data(close_friendship.close_friend)}
      else
        data = { status: false, message: close_friend.errors.full_messages.join(','), errors: close_friendship.errors.full_messages }
        @status = 422
      end
      render json: data, status: default_status
    rescue ActiveRecord::RecordNotFound
      invalid_user_response
    end

    private

    def close_friend_data(object)
      single_serializer.new(object, serializer: Api::V1::FriendSerializer)
    end

    def close_friend_params
      params.require(:close_friend).permit(:friend_id)
    end

  end
end
