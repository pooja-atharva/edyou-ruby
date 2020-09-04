require 'swagger_helper'

RSpec.describe 'api/v1/friendship', type: :request do

  properties = { id: {type: :integer}, user: {type: :object}, friend: {type: :object}, status: {type: :string} }

  path '/api/v1/friendships' do
    post 'Create an friendship' do
      tags 'Friendships'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :friendship, in: :body, schema: {
        type: :object,
        properties:{
          friendship: {
            type: :object,
            properties:{ friend_id: { type: :integer } }
          }
        },
        required: [:friendship],
      }

      response '200', 'friendship created' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:friendship) { { friend_id: 10 } }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, 'Invitation sent successfully', 'friendship')
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:friendship) {{friend_id: 0}}
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/friendships/{id}/approve' do
    post 'Approve a friendship request' do
      tags 'Friendships'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'User ID'
      response '200', 'friendship approved' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, 'Friendship request is approved', 'friendship')
        run_test!
      end

      response '401', 'Unauthorized' do
        schema type: :object, properties: ApplicationMethods.unauthorized_schema
        run_test!
      end

      response '422', 'Invalid Request' do
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/friendships/{id}/decline' do
    post 'Decline a friendship request' do
      tags 'Friendships'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'User ID'
      response '200', 'friendship approved' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, 'Friendship request is declined', 'friendship')
        run_test!
      end

      response '401', 'Unauthorized' do
        schema type: :object, properties: ApplicationMethods.unauthorized_schema
        run_test!
      end

      response '422', 'Invalid Request' do
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/friendships/{id}/cancel' do
    delete 'Cancel a friendship request' do
      tags 'Friendships'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'User ID'

      response '200', 'friendship approved' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, 'Friendship request is cancelled', 'friendship')
        run_test!
      end

      response '401', 'Unauthorized' do
        schema type: :object, properties: ApplicationMethods.unauthorized_schema
        run_test!
      end

      response '422', 'Invalid Request' do
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end
end