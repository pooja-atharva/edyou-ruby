module Api
  class V1::FriendshipsController < V1::BaseController
    before_action :validate_record, except: [:index, :create]

    def index
      ids = []
      current_user.friendships.where.not(friend_id: current_user.blocks.pluck(:id)).each do |friendship|
        ids << friendship.friend.id if friendship.friend.blocks.include?(current_user)
      end
      blocked_ids = ids.flatten + current_user.blocks.pluck(:id)
      friendships = current_user.friendships.where.not(friend_id: blocked_ids).filter_on(filter_params)
      render_success_response(
        { friendships: array_serializer.new(friendships, serializer: Api::V1::FriendshipSerializer) },
        '',  200, page_meta(friendships, filter_params)
      )
    end

    def create
      user = User.find_by_id(friendship_params[:friend_id])
      render_unprocessable_entity('User is not found') and return if user.nil?
      render_unprocessable_entity('You cannot send frindship to yourself') and return if current_user == user
      render_unprocessable_entity('User is blocked by you so you can not send frindship') and return if current_user.blocks.include?(user)
      render_unprocessable_entity('You are blocked by this user so you can not send frindship') and return if user.blocks.include?(current_user)
      friendship = current_user.friendships.with_user(friendship_params[:friend_id]).first || current_user.friendships.build(friendship_params)
      friendship.user = current_user if friendship.new_record?
      friendship.set_pending if !friendship.new_record? && friendship.unfriend?
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
      @friendship.set_cancelled!
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
      user = User.find_by_id(params[:id])
      render_unprocessable_entity('User is not found') and return if user.nil?
      render_unprocessable_entity('Can not send frindship blocked user') and return if current_user.blocks.include?(user) || user.blocks.include?(current_user)
      @friendship = current_user.friendships.with_user(params[:id]).last
      render_unprocessable_entity('Friendship record is not found.') if @friendship.nil?
    end

    def friendship_data(object)
      single_serializer.new(object, serializer: Api::V1::FriendshipSerializer)
    end

    def filter_params
      params.permit(:page, :per)
    end
  end
end
