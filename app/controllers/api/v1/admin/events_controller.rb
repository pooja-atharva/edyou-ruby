module Api
  class V1::Admin::EventsController < V1::BaseController
    before_action :set_user

    def index
      page = params[:page] || 1
      per_page = params[:per] || 25
      calendar_events = CalendarEvent.all.order(created_at: :desc).page(page).per(per_page)
      render_success_response({
        calendar_events: array_serializer.new(calendar_events, serializer: Api::V1::CalendarEventSerializer)
      })
    end

    def show
      calendar_event = CalendarEvent.find(params[:id])
      render_unprocessable_entity('Calendar Event is not found') and return if calendar_event.nil?
      render_success_response({ calendar_event: calendar_event_data(calendar_event) }, '', 200)
    end

    def destroy
      calendar_event = CalendarEvent.find(:id)
      calendar_event.destroy
      render_success_response( {} , 'Calendar Event is removed successfully', 200)
    rescue
      render_unprocessable_entity('Something went wrong. Please try again.', 500)
    end

    private
      def set_user
        render_unprocessable_entity('You are not authorized') and return unless current_user.admin?
      end

      def calendar_event_data(object)
        single_serializer.new(object, serializer: Api::V1::CalendarEventSerializer)
      end
  end
end
