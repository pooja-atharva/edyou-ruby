module Api
  class V1::UsersController < V1::BaseController
    skip_before_action :doorkeeper_authorize!, except: %i[update profile_image, show]
    before_action :set_user, except: %i[reset_password, show]

    def reset_password
      @user = User.find_by(reset_password_token: params[:reset_password_token]) rescue nil
      if @user.present? && @user.password_token_valid?
        if @user.reset_password!(params[:password])
          Doorkeeper::AccessToken.revoke_all_for(nil, @user)
          render_success_response({
            user: single_serializer.new(@user, serializer: Api::V1::UserSerializer)
          }, "Password updated successfully.")
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

    def cover_images
      if current_user.update(media_params)
        render_success_response({
          user: single_serializer.new(current_user, serializer: Api::V1::ProfileSerializer)
        }, 'Profile pic updated successfully.')
      else
        render_unprocessable_entity("Update pic failed")
      end
    end

    def profile_image
      if current_user.update(profile_image: params[:profile_image])
        render_success_response({
          user: single_serializer.new(current_user, serializer: Api::V1::UserSerializer)
        }, 'Profile pic updated successfully.')
      else
        render_unprocessable_entity("Update pic failed")
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

    def update
      profile = current_user.profile.blank? ? current_user.create_profile(profile_params) : current_user.profile.update_attributes(profile_params)
      if profile
        render_success_response({
          user: single_serializer.new(current_user.profile, serializer: Api::V1::ProfileSerializer)
        }, "Profile updated successfully.")
      else
        render_unprocessable_entity("Update failed")
      end
    end

    def show
      render_unprocessable_entity('Please give proper value') and return if user_params[:id].blank?

      user = params[:id].downcase  == 'me' ? current_user : User.find_by_id(user_params[:id])
      render_unprocessable_entity('User is does not exists.')and return if user.nil?
      user.create_profile(profile_params) if user.profile.blank?
      render_success_response({ user: profile_data(user.profile) })
    end

    private

    def profile_params
      params.permit(:class_name, :graduation, :major, :status, :attending_university, :high_school, :from_location, :gender, :religion, :language, :date_of_birth, :favourite_quotes)
    end

    def user_params
      params.permit(:id)
    end

    def media_params
      params.permit(cover_images: [])
    end

    def set_user
      @user = User.find_by(email: params[:email])
    end

    def profile_data(object)
      single_serializer.new(object, serializer: Api::V1::ProfileSerializer, current_user: current_user)
    end
  end
end
