module Api
    class V1::LikesController < V1::BaseController
      serialization_scope :current_user

      def create
        post = Post.find(params[:id]) rescue nil
        like = post.likes.build(user_id: current_user.id)
        if like.save
          render_success_response({
            post: single_serializer.new(post, serializer: Api::V1::PostSerializer, scope: current_user)
          }, "Liked successfully.")
        else
          render_unprocessable_entity(like.errors.full_messages.join(','))
        end
      end

      def destroy
        post = Post.find(params[:id]) rescue nil
        like = post.likes.find_by(user_id: current_user.id)
        if like.present?
          like.destroy
          render_success_response({
            post: single_serializer.new(post, serializer: Api::V1::PostSerializer, scope: current_user)
          }, "unliked successfully.")
        else
          render_unprocessable_entity('Post not liked')
        end
      end

      def index
        post = Post.find(params[:id]) rescue nil
          render_success_response({
            users: array_serializer.new(post.likes.map(&:user), serializer: Api::V1::UserSerializer)
          })
      end

    end
  end
