module Api
  class V1::FriendsController < V1::BaseController

    def index
      friends = current_user.friends
      data = {
        status: true, message: '',
        data: array_serializer.new(friends, serializer: Api::V1::FriendSerializer),
      }
      render json: data, status: default_status
    end

    def search
      friends = current_user.friends.search_with_name(params[:query])
      data = {
        status: true, message: '',
        data: array_serializer.new(friends, serializer: Api::V1::FriendSerializer),
      }
      render json: data, status: default_status
    end

    def feed
      friends = current_user.friends
      feeds = Post.where(user_id: friends.ids)
      data = {
        status: true, message: '',
        data: array_serializer.new(feeds, serializer: Api::V1::PostSerializer),
      }
      render json: data, status: default_status
    end
  end
end
