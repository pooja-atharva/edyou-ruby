require 'swagger_helper'

RSpec.describe 'api/v1/followings', type: :request do
  properties = {
    id: { type: :integer },
    follower: { type: :object },
    following: { type: :object },
  }

  path '/api/v1/followings' do
    get 'List of Followings' do
      tags 'Followings'
      security [Bearer: []]
      parameter name: :per, in: :query, type: :integer, value: Kaminari.config.default_per_page
      parameter name: :page, in: :query, type: :integer, value: 1

      response '200', 'List of Followings' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_plural_schema(properties, nil, 'follows')
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:follower) {{}}
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/followings' do
    post 'Follow user' do
      tags 'Followings'
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
        schema type: :object, properties: ApplicationMethods.success_schema(properties, 'You are now following this user', 'follow')
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:follower) {{id: 0}}
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/followings/{id}' do
    delete 'Unfollow user' do
      tags 'Followings'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'User ID'

      response '200', 'Unfollow user' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: { status: { type: :boolean, example: true }, message: { type: :string, example: 'You are no longer following this user' }}
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