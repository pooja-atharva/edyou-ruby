class UserMailer < ApplicationMailer
  def send_otp_for_forgot(user)
    @user = user
    mail(to: @user.email, subject: 'Forgot password')
  end
end
