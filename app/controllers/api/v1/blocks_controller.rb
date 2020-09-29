module Api
  class V1::BlocksController < V1::BaseController
    before_action :validate_record, only: [:create, :destroy]

    def index
      blocks = Follow.blocked.where(followable: current_user)
      blocks = blocks.where(follower_type: block_list_params[:reference_type]) if block_list_params[:reference_type]
      blocks = blocks.filter_on(filter_params)
      render_success_response(
        { blocks: array_serializer.new(blocks, serializer: Api::V1::BlockSerializer) },
        '',  200, page_meta(blocks, filter_params)
      )
    end

    def create
      if @block.present?
        message = 'You have already blocked'
      else
        current_user.stop_following(@reference)
        @block = current_user.block(@reference)
        message = 'You have blocked successfully'
      end
      render_success_response(
        { block: single_serializer.new(@block, serializer: Api::V1::BlockSerializer) },
        message
      )
    end

    def destroy
      if @block.present?
        current_user.unblock(@reference)
        render_success_response(nil, 'You have unblocked successfully')
      else
        render_unprocessable_entity('Reference object is not found to unblock.')
      end
    end

    private

    def validate_record
      render_unprocessable_entity('You cannot block/unblock this entity.') and return if block_params[:reference_type].present? && !block_params[:reference_type].in?(Constant::BLOCK_SUPPORT_OBJECTS)
      @reference = block_params[:reference_type].constantize.find_by_id(block_params[:reference_id])
      render_unprocessable_entity("#{params[:reference_type].constantize} is not found") and return if @reference.nil?
      render_unprocessable_entity('You cannot block/unblock yourself') and return if @reference.is_a?(User) && current_user == @reference
      # render_unprocessable_entity('You cannot block/unblock your own entity') and return if params[:reference_type] != "User" && @reference.user_id.present? && current_user.id == @reference.user_id
      @block = Follow.blocked.where(followable: current_user, follower: @reference).first
    end

    def filter_params
      params.permit(:page, :per)
    end

    def block_params
      params.require(:block).permit(:reference_id, :reference_type)
    end

    def block_list_params
      params.permit(:reference_type)
    end
  end
end
