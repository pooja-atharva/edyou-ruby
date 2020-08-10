module Api
  class V1::BlocksController < V1::BaseController

    def index
      blocks = Follow.blocked.where(followable: current_user)
      blocks = blocks.where(follower_type: block_params[:reference_type]) if block_params[:reference_type]
      blocks = blocks.filter_on(filter_params)
      render_success_response(
        { blocks: array_serializer.new(blocks, serializer: Api::V1::BlockSerializer) },
        '',  200, page_meta(blocks, filter_params)
      )
    end

    def create
      allow_block = ['User', 'Post', 'Group']
      render_unprocessable_entity("You cannot block this entity.") and return if block_params[:reference_type].present? && !allow_block.include?(params[:reference_type])
      block_data = params[:reference_type].constantize.find_by_id(params[:reference_id])
      render_unprocessable_entity("#{params[:reference_type].constantize} is not found") and return if block_data.nil?
      render_unprocessable_entity('You cannot block yourself') and return if params[:reference_type] == "User" && block_data.id.present? && current_user.id == block_data.id
      render_unprocessable_entity('You cannot block your own entity') and return if params[:reference_type] != "User" && block_data.user_id.present? && current_user.id == block_data.user_id
      block = Follow.blocked.where(followable: current_user, follower: block_data).first
      if  block.present?
        message = 'You have already blocked'
      else
        current_user.block(block_data)
        message = 'You have blocked successfully'
      end
      data = {
        status: true, message: message  ,
        data: nil
      }
      render json: data, status: default_status
    end

    def destroy
      allow_block = ['User', 'Post', 'Group']
      render_unprocessable_entity("You cannot unblock this entity.") and return if block_params[:reference_type].present? && !allow_block.include?(block_params[:reference_type])
      block_data = block_params[:reference_type].constantize.find_by_id(block_params[:reference_id])
      render_unprocessable_entity("#{block_params[:reference_type].constantize} is not found") and return if block_data.nil?
      block = Follow.blocked.where(followable: current_user, follower: block_data).first
      if !block.present?
        render_unprocessable_entity('You have already unblocked.')
      else
        current_user.unblock(block_data)
        data = {
          status: true, message: 'You have unblocked successfully',
          data: single_serializer.new(block, serializer: Api::V1::BlockSerializer)
        }
        render json: data, status: default_status
      end
    end

    private

    def filter_params
      params.permit(:page, :per)
    end

    def block_params
      params.permit(:reference_id, :reference_type)
    end
  end
end
