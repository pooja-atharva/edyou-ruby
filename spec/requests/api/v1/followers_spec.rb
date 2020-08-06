require 'swagger_helper'

RSpec.describe 'api/v1/followers', type: :request do
  properties = {
    id: { type: :integer },
    follower: { type: :object },
    following: { type: :object },
  }
 
  path '/api/v1/followers' do
    get 'List of Followers' do
      tags 'Followers'
      security [Bearer: []]
      consumes 'application/json'

      response '200', 'List of Followers' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_plural_schema(properties)
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:follower) {{}}
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/followers' do
    post 'Follow user' do
      tags 'Followers'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :user_id, in: :body, schema: {
        type: :string,
        properties:{
          user_id: { type: :integer }
        },
        required: [:user_id],
      }

      response '200', 'Follow user' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:follower) { { id: 1 } }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, 'You are now following this user')
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:follower) {{id: 0}}
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/followers/{id}' do
    delete 'Unfollow user' do
      tags 'Followers'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :user_id, in: :path, type: :string, description: 'User ID'

      response '200', 'Unfollow user' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, 'You are no longer following this user')
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