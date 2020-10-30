module Api
  class V1::RoommatesController < V1::BaseController
    def index
      roommates = current_user.roommates.filter_on(filter_params)
      render_success_response({
        roommates: array_serializer.new(roommates, serializer: Api::V1::FriendSerializer)},'',  200, page_meta(roommates, filter_params)
      )
    end

    def create
      roommateship = current_user.roommateships.new(roommate_params)
      roommateship.relavance = 'roommates'
      if roommateship.save
        render_success_response({roommate: roommate_data(roommateship.roommate)}, 'Roommate is added successfully.')
      else
        render_unprocessable_entity(roommateship.errors.full_messages.join(','))
      end
    rescue ActiveRecord::RecordNotFound
      invalid_user_response
    end

    def destroy
      roommateship = current_user.roommateships.find_by(friend_id: params[:id])
      render_unprocessable_entity('User is not your roommate') and return if roommateship.nil?
      roommateship.destroy
      render_success_response( {} , 'Roommate is removed successfully',200)
    rescue
      render_unprocessable_entity('Something went wrong. Please try again.', 500)
    end

    private

    def roommate_data(object)
      single_serializer.new(object, serializer: Api::V1::FriendSerializer)
    end

    def roommate_params
      params.require(:roommate).permit(:friend_id)
    end

    def filter_params
      params.permit(:page, :per)
    end
  end
end
