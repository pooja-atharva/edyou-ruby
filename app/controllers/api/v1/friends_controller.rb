module Api
  class V1::FriendsController < V1::BaseController

    def index
      user = params[:user_id].present? ? User.find_by(id: params[:user_id]) : current_user
      render_unprocessable_entity('User is does not exists.') and return if user.nil?
      friends = user.friends.filter_on(filter_params)
      render_success_response(
        { friends: array_serializer.new(friends, serializer: Api::V1::FriendSerializer) },
        '',  200, page_meta(friends, filter_params)
      )
    end

    def search
      friends = current_user.friends.search_with_name(params[:query])
      data = {
        status: true, message: '',
        data: array_serializer.new(friends, serializer: Api::V1::FriendSerializer),
      }
      render json: data, status: default_status
    end

    def feeds
      friends = current_user.friends
      feeds = Post.joins(:permission).merge(Permission.include_permission_type)
      feeds = feeds.where('permission_types.action_name = ? or permission_types.action_name = ? or (permission_types.action_name = ? and not (posts.access_requirement_ids @> ARRAY[?]::integer[])) or (permission_types.action_name = ? and (posts.access_requirement_ids @> ARRAY[?]::integer[]))', 'Public', 'Friends', 'Friends, except...', [current_user.id], 'Specific Friends...', [current_user.id])
      feeds = feeds.where(user_id: friends.ids)
      feeds = feeds.sort_by(&:'created_at')
      feeds = feeds.reverse.take(10)
      data = {
        status: true, message: '',
        data: array_serializer.new(feeds, serializer: Api::V1::PostSerializer),
      }
      render json: data, status: default_status
    end

    def filter_params
      params.permit(:page, :per)
    end
  end
end
