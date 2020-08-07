module Api
  class V1::PostsController < V1::BaseController
    def create
      post = Post.new(post_params)
      post.user = current_user
      post.publish_date = Time.now if post.publish_date.blank?
      if post.save
        data = { status: true, message: 'Post is created successfully', data: post_data(post)}
      else
        data = { status: false, message: post.errors.full_messages.join(','), errors: post.errors.full_messages }
        @status = 422
      end
      render json: data, status: default_status
    end

    def audience
      permissions = Permission.post_permissions
      render json: { status: true, data: array_serializer.new(permissions, serializer: Api::V1::PermissionSerializer) }
    end

    private
      def post_params
        params.require(:post).permit(:body, :publish_date, :parent_id, :parent_type, :feeling_id, :activity_id, taggings_attributes: [:id, :tagger_id, :tagger_type])
      end

      def post_data(object)
        single_serializer.new(object, serializer: Api::V1::PostSerializer)
      end
  end
end
