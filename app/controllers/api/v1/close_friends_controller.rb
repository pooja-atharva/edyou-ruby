module Api
  class V1::CloseFriendsController < V1::BaseController
    def index
      close_friends = current_user.close_friends
      render_success_response({
        close_friends: array_serializer.new(close_friends, serializer: Api::V1::FriendSerializer)},'',  200, page_meta(close_friends, filter_params)
      )
    end

    def create
      close_friendship = current_user.close_friendships.new(close_friend_params)
      close_friendship.relavance = 'close_friend'
      if close_friendship.save
        render_success_response({close_friend: close_friend_data(close_friendship.close_friend)}, 'Close friend is added successfully.')
      else
        render_unprocessable_entity(close_friend.errors.full_messages.join(','))
      end
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

    def filter_params
      params.permit(:page, :per)
    end
  end
end
