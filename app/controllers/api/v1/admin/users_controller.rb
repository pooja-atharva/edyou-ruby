module Api
  class V1::Admin::UsersController < V1::BaseController
    before_action :set_user, only: [:show, :update]

    def show
      @user.create_profile(profile_params) if @user.profile.blank?
      render_success_response({ user: profile_data(@user.profile) })
    end

    def update
      @user.update_attributes(user_params)
      render_success_response(
        { user: single_serializer.new(@user, serializer: Api::V1::UserSerializer) },
        "User is updated successfully"
      )
    end

    private

    def profile_params
      params.permit(:class_name, :graduation, :major, :status, :attending_university, :high_school, :from_location, :gender, :religion, :language, :date_of_birth, :favourite_quotes, :country)
    end

    def user_params
      params.require(:user).permit(:blocked)
    end

    def set_user
      render_unprocessable_entity('You are not authorized') and return unless current_user.admin?
      render_unprocessable_entity('Please give proper value') and return if params[:id].blank?
      @user = User.find_by_id(params[:id])
      render_unprocessable_entity('User is does not exists.') and return if @user.nil?
    end

    def profile_data(object)
      single_serializer.new(object, serializer: Api::V1::ProfileSerializer, current_user: current_user)
    end

    def filter_params
      params.permit(:page, :per)
    end
  end
end
