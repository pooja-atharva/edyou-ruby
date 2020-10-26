module Api
  class V1::PostsController < V1::BaseController
    serialization_scope :current_user

    def create
      post = Post.new(post_params)
      post_defaults(post)
      if post.save
        post.create_activity :create, owner: current_user
        data = { status: true, message: 'Post is created successfully', data: post_data(post)}
      else
        data = { status: false, message: post.errors.full_messages.join(','), errors: post.errors.full_messages }
        @status = 422
      end
      render json: data, status: default_status
    end

    def show
      post = Post.find(params[:id])
      data = {
        status: true, message: '',
        data: single_serializer.new(post, serializer: Api::V1::PostSerializer, scope: current_user),
      }
      render json: data, status: default_status
    end

    def audience
      permissions = Permission.post_permissions
      render json: { status: true, data: array_serializer.new(permissions, serializer: Api::V1::PermissionSerializer, scope: current_user) }
    end

    def report_post
      post = Post.find(params[:id])
      post.post_reports.new(user: current_user, reason: post_params[:reason])
      if post.save
        render_success_response(
          { post: post_data(post) }, 'Post reported successfully',  200
        )
      else
        render_unprocessable_entity(post.errors.full_messages.join(','))
      end
    end

    def search
      render_unprocessable_entity('Query params must be present.') and return unless search_params[:query].present?
      posts = Post.joins(:taggings).where(taggings: { context: search_params[:query] }).filter_on(filter_params)
      if posts.present?
        render_success_response(
          { posts: array_serializer.new(posts, serializer: Api::V1::PostSerializer, scope: current_user) },
          '',  200, page_meta(posts, filter_params)
        )
      else
        render_success_response(nil, 'No post found.')
      end
    end

    private

      def post_defaults(post)
        post.user = current_user
        post.publish_date = Time.now if post.publish_date.blank?
        post.permission = current_user.default_permission('Post') if post.permission_id.blank?
        post.status = :approved if post.status.blank?
      end

      def post_params
        params.require(:post).permit(:body, :publish_date, :parent_id,
          :parent_type, :feeling_id, :activity_id, :permission_id,
          :delete_post_after_24_hour, :status, :location_id, :reason,
          group_ids: [],
          taggings_attributes: [:id, :tagger_id, :tagger_type],
          access_requirement_ids: [])
      end

      def post_data(object)
        single_serializer.new(object, serializer: Api::V1::PostSerializer, scope: current_user)
      end

      def search_params
        params.permit(:query)
      end

      def filter_params
        params.permit(:page, :per)
      end
  end
end
