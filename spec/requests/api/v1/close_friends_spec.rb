require 'swagger_helper'

RSpec.describe 'api/v1/close_friends', type: :request do
  properties = { id: {type: :integer}, name: {type: :string}}

  close_friend_properties = {
    friend_id: { type: :integer }
  }

  path '/api/v1/close_friends' do
    get 'Get User Close Friends' do
      tags 'Close Friends'
      security [Bearer: []]
      consumes 'application/json'

      response '200', 'Close Friends list' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:close_friend) { { name: 'sample' } }
        schema type: :object, properties: ApplicationMethods.success_plural_schema(properties)
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:close_friend) {{name: 'sample'}}
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/close_friends' do
    post 'Create a Close Friends' do
      tags 'Close Friends'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :close_friend, in: :body, schema: {
        type: :object,
        properties: { close_friends: { type: :object, properties: close_friend_properties } },
        required: [:close_friend],
      }
      response '200', 'Post created' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:close_friend) { { friend_id: 1 } }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, 'Close friend is added successfully')
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:close_friend) { { friend_id: 0 } }
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

end
