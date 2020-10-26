require 'swagger_helper'

RSpec.describe 'api/v1/admin/events', type: :request do
  attributes = {
    id: { type: :integer },
    title: { type: :string },
    description: { type: :string },
    epoc_datetime_at: { type: :integer },
    price: { type: :string },
    event_type: { type: :string },
    location: { type: :string },
    user: { type: :object },
    media_items: {
      type: :array,
      items: {
        type: :object ,
        properties: { id: { type: :integer}, url: { type: :string } }
      }
    },
    users: {
      type: :array,
      items: {
        type: :object
      }
    },
    groups: {
      type: :array,
      items: {
        type: :object
      }
    },
    invite: {type: :string},
    attendance: {
      type: :object,
      properties: {
        'Yes': { type: :integer },
        'No': { type: :integer },
        'Maybe': { type: :integer }
      }
    },
    attendance_status: { type: :string }
  }

  path '/api/v1/admin/events' do
    get 'Get Events' do
      tags 'Admin Events'
      security [Bearer: []]
      consumes 'application/json'

      parameter name: :per, in: :query, type: :integer, value: Kaminari.config.default_per_page
      parameter name: :page, in: :query, type: :integer, value: 1

      response '200', 'Events list' do
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

  path '/api/v1/admin/events/{id}' do
    get 'Get Events' do
      tags 'Admin Events'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'Event ID'

      response '200', 'Calendar Event detail' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_plural_schema(attributes, '', 'calendar_events')
        run_test!
      end

      response '422', 'Invalid Request' do
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/admin/events/{id}' do
    delete 'delete event' do
      tags 'Admin Events'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'Success' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        run_test!
      end

      response '422', 'Invalid Request' do
        run_test!
      end
    end
  end
end
