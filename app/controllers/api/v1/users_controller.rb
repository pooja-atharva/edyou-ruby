module Api
  class V1::UsersController < V1::BaseController
    skip_before_action :doorkeeper_authorize!
    before_action :set_user, except: %i[reset_password]

    def reset_password
      @user = User.find_by(reset_password_token: params[:reset_password_token]) rescue nil
      if @user.present? && @user.password_token_valid?
        if @user.reset_password!(params[:password])
          Doorkeeper::AccessToken.revoke_all_for(nil, @user)
          render_success_response({
            user: single_serializer(@user, Api::V1::UserSerializer)}, 'Password updated successfully.')
        else
          render_unprocessable_entity('Update password failed.')
        end
      else
        render_unprocessable_entity('Invalid user or token')
      end
    end

    def verify_otp
      if @user.present?
        if @user.authenticate_otp(params[:otp], drift: 60)
            @user.generate_password_token!
            render_success_response({ reset_password_token: @user.reset_password_token }, 'OTP verified successfully.')
        else
          render_unprocessable_entity('Otp is incorrect.')
        end
      else
        render_unprocessable_entity('User is not present.')
      end
    end

    def send_otp
      if @user.present?
          #@user.send_otp_for_forgot
          render_success_response({ otp: @user.otp_code }, 'OTP sent successfully.')
      else
        render_unprocessable_entity('User is not present.')
      end
    end

    def signout
      doorkeeper_token.try(:revoke)
      render json: { success: true, message: 'User logged out successfully', data: {}, meta: {}, errors: [] }
    end

    private

    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def set_user
      @user = User.find_by(email: params[:email])
    end
  end
end