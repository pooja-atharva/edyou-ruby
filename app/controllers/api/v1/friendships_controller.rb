module Api
  class V1::FriendshipsController < V1::BaseController
    before_action :validate_record, except: [:create]

    def create
      friendship = current_user.friendships.with_user(friendship_params[:friend_id]).first || current_user.friendships.build(friendship_params)
      friendship.user = current_user if friendship.new_record?
      if friendship.save
        render_success_response(
          { friendship: friendship_data(friendship) }, 'Invitation sent successfully'
        )
      else
        render_unprocessable_entity(friendship.errors.full_messages.join(','))
      end
    end

    def approve
      @friendship.set_approved!
      render_success_response(
        { friendship: friendship_data(@friendship) }, 'Friendship request is approved'
      )
    end

    def decline
      @friendship.set_declined!
      render_success_response(
        { friendship: friendship_data(@friendship) }, 'Friendship request is declined'
      )
    end

    def cancel
      @friendship.set_declined!
      render_success_response(
        { friendship: friendship_data(@friendship) }, 'Friendship request is cancelled'
      )
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
      render_unprocessable_entity('Friendship record is not found.') if @friendship.nil?
    end

    def friendship_data(object)
      single_serializer.new(object, serializer: Api::V1::FriendshipSerializer)
    end
  end
end