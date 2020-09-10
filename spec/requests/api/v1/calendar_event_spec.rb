require 'swagger_helper'

RSpec.describe 'api/v1/calendar_events', type: :request do

  attributes = {
    id: { type: :integer },
    title: { type: :string },
    description: { type: :string },
    epoc_datetime_at: { type: :integer },
    price: { type: :string },
    event_type: { type: :string },
    user: { type: :object },
    media_items: {
      type: :array,
      items: {
        type: :object ,
        properties: { id: { type: :integer}, url: { type: :string } }
      }
    },
    attendance: {
      type: :object,
      properties: {
        'Yes': { type: :integer },
        'No': { type: :integer },
        'Maybe': { type: :integer }
      }
    }
  }
  
  path '/api/v1/calendar_events' do
    get 'Get Calendar Events' do
      tags 'Calendar Events'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :per, in: :query, type: :integer, value: Kaminari.config.default_per_page
      parameter name: :page, in: :query, type: :integer, value: 1

      response '200', 'Calendar Events list' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_plural_schema(attributes, nil, 'calendar_events')
        run_test!
      end

      response '422', 'Invalid Request' do
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/calendar_events' do
    post 'Create Calendar Event' do
      tags 'Calendar Events'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :calendar_event, in: :body, schema: {
        type: :object,
        properties: {
          calendar_event: {
            type: :object,
            properties: {
              title: { type: :string},
              description: { type: :string },
              epoc_datetime_at: { type: :string },
              price: { type: :string },
              location: { type: :string },
              event_type: { type: :string },
              media_tokens: {type: :array, items: { type: :string }}
            }
          }
        },
        required: [:calendar_event],
      }

      response '200', 'Calendar Event' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:calendar_event) { {
          title: 'Sample Title', description: 'Sample Description', epoc_datetime_at: '1598876283', price: '50',
          location: 'Sample Location', event_type: 'Sample Event Type'
        } }
        schema type: :object, properties: ApplicationMethods.success_schema(attributes, 'Event is created successfully', 'calendar_event')
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:calendar_event) { {
          title: 'Sample Title', description: 'Sample Description', datetime_at: '1598876283', price: '50',
          location: 'Sample Location', event_type: 'Sample Event Type'
        } }
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/calendar_events/{id}/' do
    put 'Update Calendar Event' do
      tags 'Calendar Events'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'Event ID'
      parameter name: :calendar_event, in: :body, schema: {
        type: :object,
        properties: {
          calendar_event: {
            type: :object,
            properties: {
              title: { type: :string},
              description: { type: :string },
              epoc_datetime_at: { type: :string },
              price: { type: :string },
              location: { type: :string },
              event_type: { type: :string },
              media_tokens: { type: :array, items: { type: :string }}
            }
          }
        },
        required: [:calendar_event],
      }

      response '200', 'Calendar Event' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:calendar_event) { {
          title: 'Sample Title', description: 'Sample Description', epoc_datetime_at: '1598876283', price: '50',
          location: 'Sample Location', event_type: 'Sample Event Type'
        } }
        schema type: :object, properties: ApplicationMethods.success_schema(attributes, 'Event is updated successfully', 'calendar_event')
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:calendar_event) { {
          title: 'Sample Title', description: 'Sample Description', datetime_at: '1598876283', price: '50',
          location: 'Sample Location', event_type: 'Sample Event Type'
        } }
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end

    path '/api/v1/calendar_events/{id}' do
      get 'Event Details' do
        tags 'Calendar Events'
        security [Bearer: []]
        consumes 'application/json'
        parameter name: :id, in: :path, type: :string, description: 'Event ID'
        response '200', 'Event Details' do
          let(:'Authorization') { 'Bearer ' + generate_token }
          schema type: :object, properties: ApplicationMethods.success_schema(attributes, nil, 'calendar_event')
          run_test!
        end

        response '422', 'Invalid Request' do
          schema '$ref' => '#/components/schemas/errors_object'
          run_test!
        end
      end
    end

    path '/api/v1/calendar_events/{id}' do
      delete 'Delete Calendar Event' do
        tags 'Calendar Events'
        security [Bearer: []]
        consumes 'application/json'
        parameter name: :id, in: :path, type: :string, description: 'Calendar Event ID'

        response '200', 'Event is removed successfully' do
          let(:'Authorization') { 'Bearer ' + generate_token }
          run_test!
        end

        response '422', 'Invalid Request' do
          schema '$ref' => '#/components/schemas/errors_object'
          run_test!
        end
      end
    end

    path '/api/v1/calendar_events/{id}/add_media_item' do
      post 'Add media item in Calendar Event' do
        tags 'Calendar Events'
        security [Bearer: []]
        consumes 'application/json'
        parameter name: :id, in: :path, type: :string, description: 'Calendar Event ID'
        parameter name: :media_item, in: :formData, type: :file, required: true

        response '200', 'Event Details' do
          let(:'Authorization') { 'Bearer ' + generate_token }
          schema type: :object, properties: ApplicationMethods.success_schema(attributes, 'Media item is added successfully in event', 'calendar_event')
          run_test!
        end

        response '422', 'Invalid Request' do
          schema '$ref' => '#/components/schemas/errors_object'
          run_test!
        end
      end
    end

    path '/api/v1/calendar_events/{id}/remove_media_item/{media_item_id}' do
      delete 'Remove media item from Calendar Event' do
        tags 'Calendar Events'
        security [Bearer: []]
        consumes 'application/json'
        parameter name: :id, in: :path, type: :string, description: 'Calendar Event ID'
        parameter name: :media_item_id, in: :path, type: :string, description: 'Media Item ID'

        response '200', 'Event Details' do
          let(:'Authorization') { 'Bearer ' + generate_token }
          schema type: :object, properties: ApplicationMethods.success_schema(attributes, 'Media item is removed successfully from the event', 'calendar_event')
          run_test!
        end

        response '422', 'Invalid Request' do
          schema '$ref' => '#/components/schemas/errors_object'
          run_test!
        end
      end
    end
  end

  path '/api/v1/calendar_events/{id}/attendance' do
    put 'Event Attendance for Calendar Events' do
      tags 'Calendar Events'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'Calendar Event ID'
      parameter name: :status, in: :path, type: :string, value: "Yes", description: 'Status', enum: Constant::EVENT_ATTENDANCE_STATUS

      response '200', 'Event attendance' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_schema(
          attributes, 'Your response is updated successfully for this Event', 'calendar_event')
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:follower) {{id: 0}}
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end
end
