module Api
    class V1::SupportTicketsController < V1::BaseController

      def create
        # support_ticket = current_user.support_tickets.new(support_params)
        # if support_ticket.save
        #   render_success_response({
        #     support_ticket: single_serializer.new(support_ticket, serializer: Api::V1::Serializer)
        #   }, "Support ticket created successfully.")
        # else
        #   render_unprocessable_entity(support_ticket.errors.full_messages.join(','))
        # end
        SupportTicketMailer.send_ticket(support_params).deliver_now
        render json: {success: true, message: "Support Ticket created successfully", data: {}, meta: {}, errors: [] }
      end

      private

      def support_params
        params.permit(:reason, :name, :email, :phone, :message)
      end

    end
  end
