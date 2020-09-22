module Api
    class V1::CommentsController < V1::BaseController

      def create
        post = Post.find(params[:id]) rescue nil
        comment = post.comments.build(user_id: current_user.id, content: params[:content])
        if comment.save
          render_success_response({
            comments: array_serializer.new(post.comments, serializer: Api::V1::CommentSerializer)
          }, "Commented successfully.")
        else
          render_unprocessable_entity(comment.errors.full_messages.join(','))
        end
      end

      def index
        post = Post.find(params[:id]) rescue nil
          render_success_response({
            comments: array_serializer.new(post.comments, serializer: Api::V1::CommentSerializer)
          })
      end

    end
  end
