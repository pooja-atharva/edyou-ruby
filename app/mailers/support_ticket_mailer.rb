
class SupportTicketMailer < ApplicationMailer

  layout "mailer"

  def send_ticket(params)
    @reason = params[:reason]
    @email = params[:email]
    @name = params[:name]
    @phone = params[:phone]
    @message = params[:message]
    mail(:to => @email, :subject => "New Support Request")

  end
end
