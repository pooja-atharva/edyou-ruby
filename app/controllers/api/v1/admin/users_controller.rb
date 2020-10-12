module Api
  class V1::Admin::UsersController < V1::BaseController
    before_action :set_user, only: [:update, :destroy]

    def index
      users = User.blocked_users.filter_on(filter_params)
      render_success_response(
        { users: array_serializer.new(users, serializer: Api::V1::UserSerializer) },
        '',  200, page_meta(users, filter_params)
      )
    end

    def update
      render_unprocessable_entity('You have already blocked this user') and return if @user.blocked
      @user.update_attribute(:blocked, true)
      render_success_response(
        { user: single_serializer.new(@user, serializer: Api::V1::UserSerializer) },
        'You have blocked successfully'
      )
    end

    def destroy
      render_unprocessable_entity("You haven't blocked this user") and return if !@user.blocked
      @user.update_attribute(:blocked, false)
      render_success_response(
        { user: single_serializer.new(@user, serializer: Api::V1::UserSerializer) },
        'You have unblocked successfully'
      )
    end

    private

    def set_user
      render_unprocessable_entity('You are not authorized') and return if !current_user.admin
      @user = User.find_by(id: params[:id])
      render_unprocessable_entity('User is does not exists.') and return if @user.nil?
    end

    def filter_params
      params.permit(:page, :per)
    end
  end
end
