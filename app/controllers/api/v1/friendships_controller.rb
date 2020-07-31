module Api
  class V1::FriendshipsController < V1::BaseController
    before_action :validate_record, except: [:create]

    def create
      friendship = current_user.friendships.with_user(friendship_params[:friend_id]).first || current_user.friendships.build(friendship_params)
      friendship.user = current_user if friendship.new_record?
      if friendship.save
        data = { status: true, message: 'Invitation sent successfully', data: friendship_data(friendship)}
      else
        data = { status: false, message: friendship.errors.full_messages.join(','), errors: friendship.errors.full_messages }
        @status = 422
      end
      render json: data, status: default_status
    end

    def approve
      @friendship.set_approved!
      render json: { status: true, message: 'Friendship request is approved', data: friendship_data(@friendship)}
    end

    def decline
      @friendship.set_declined!
      render json: { status: true, message: 'Friendship request is declined', data: friendship_data(@friendship)}
    end

    def cancel
      @friendship.set_declined!
      render json: { status: true, message: 'Friendship request is cancelled', data: friendship_data(@friendship)}
    end

    private

    def friendship_params
      params.require(:friendship).permit(:friend_id)
    end

    def friendship_update_params
      params.require(:friendship).permit(:status)
    end

    def validate_record
      @friendship = current_user.friendships.with_user(params[:id]).last
      render json: {status: false, message: 'Friendship record is not found.'}, status: 404 if @friendship.nil?
    end

    def friendship_data(object)
      single_serializer.new(object, serializer: Api::V1::FriendshipSerializer)
    end
  end
end