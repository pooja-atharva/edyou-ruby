module Api
  class V1::CalendarEventsController < V1::BaseController
    before_action :validate_record, except: [:create, :index, :attendance, :show]

    def index
      events = current_user.calendar_events.filter_on(filter_params).includes(:user)
      render_success_response(
        { calendar_events: array_serializer.new(events, serializer: Api::V1::CalendarEventSerializer) },
        '',  200, page_meta(events, filter_params)
      )
    end

    def create
      event = current_user.calendar_events.new(calendar_event_params)
      if event.save
        render_success_response(
          { calendar_event: event_data(event) }, 'Event is created successfully',  200
        )
      else
        render_unprocessable_entity(@event.errors.full_messages.join(','))
      end
    rescue
      invalid_media_item_response
    end

    def update
      if @event.update_attributes(calendar_event_params)
        render_success_response(
          { calendar_event: event_data(@event) }, 'Event is updated successfully',  200
        )
      else
        render_unprocessable_entity(@event.errors.full_messages.join(','))
      end
    rescue
      invalid_media_item_response
    end

    def your_events
      render_success_response({ calendar_event: event_data(@event) }, '',  200 )
    end

    def show
      @event = CalendarEvent.find_by_id(params[:id])
      render_unprocessable_entity('Event is not found') if @event.nil?
      render_success_response({ calendar_event: event_data(@event) }, '',  200 )
    end

    def destroy
      @event.destroy
      render_success_response( {} , 'Event is removed successfully',  200 )
    rescue
      render_unprocessable_entity('Something went wrong. Please try again.', 500)
    end

    def add_media_item
      if @event.media_items.attach(params[:media_item])
        render_success_response(
          { calendar_event: event_data(@event) }, 'Media item is added successfully in event',  200
        )
      else
        render_unprocessable_entity(@event.errors.full_messages.join(','))
      end
    rescue
      invalid_media_item_response
    end

    def remove_media_item
      attachment = @event.media_items.find_by_id(params[:media_item_id])
      render_unprocessable_entity('Attachment is not found') and return if attachment.nil?
      if attachment.purge
        render_success_response(
          { calendar_event: event_data(@event) }, 'Media item is removed successfully from the event',  200
        )
      else
        render_unprocessable_entity(@event.errors.full_messages.join(','))
      end
    end

    def attendance
      render_unprocessable_entity('Please give propar status value.') and return if params[:status].present? && !params[:status].in?(Constant::EVENT_ATTENDANCE_STATUS)
      event = CalendarEvent.active.find_by(id: params[:id])
      render_unprocessable_entity('Event is not found or passed') and return if event.nil?
      event_attendance = current_user.event_attendances.find_by(calendar_event_id: params[:id])
      event_attendance.status = params[:status]
      if event_attendance.save
        render_success_response(
          { calendar_event: event_data(event) }, 'Your response is updated successfully for this Event',  200
        )
      else
        render_unprocessable_entity_response(event_attendance.full_messages.join(', '))
      end
    end

    private

    def calendar_event_params
      params.require(:calendar_event)
        .permit(:title, :description, :epoc_datetime_at, :location, :price, :event_type, media_tokens: [])
    end

    def event_data(object)
      single_serializer.new(object, serializer: Api::V1::CalendarEventSerializer, current_user: current_user)
    end

    def validate_record
      @event = current_user.calendar_events.find_by_id(params[:id])
      render_unprocessable_entity('Event is not found') if @event.nil?
    end

    def filter_params
      params.permit(:page, :per)
    end

    def invalid_media_item_response
      render_unprocessable_entity('Media item is invalid. Please upload valid media item')
    end
  end
end
