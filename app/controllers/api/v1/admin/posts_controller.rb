module Api
  class V1::Admin::PostsController < V1::BaseController
    before_action :set_user

    def index
      page = params[:page] || 1
      per_page = params[:per] || 25
      posts = Post.all.order(created_at: :desc).page(page ).per(per_page)
      render_success_response({
        posts: array_serializer.new(posts, serializer: Api::V1::PostSerializer)
      })
    end

    def show
      post = Post.find(params[:id])
      render_unprocessable_entity('Post is not found') and return if post.nil?
      render_success_response({ post: post_data(post) }, '',  200 )
    end

    def destroy
      post = Post.find(:id)
      post.destroy
      render_success_response( {} , 'Post is removed successfully',  200 )
    rescue
      render_unprocessable_entity('Something went wrong. Please try again.', 500)
    end

    private
      def set_user
        render_unprocessable_entity('You are not authorized') and return unless current_user.admin?
      end

      def post_data(object)
        single_serializer.new(object, serializer: Api::V1::PostSerializer)
      end
  end
end
