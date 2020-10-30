require 'swagger_helper'

RSpec.describe 'api/v1/roommates', type: :request do
  properties = { id: {type: :integer}, name: {type: :string}}

  roommate_properties = {
    friend_id: { type: :integer }
  }

  path '/api/v1/roommates' do
    get 'Get User Roommates' do
      tags 'Roommates'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :per, in: :query, type: :integer, value: Kaminari.config.default_per_page
      parameter name: :page, in: :query, type: :integer, value: 1

      response '200', 'Roommates list' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:roommate) { { name: 'sample' } }
        schema type: :object, properties: ApplicationMethods.success_plural_schema(properties, nil ,'roommates')
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:roommate) {{name: 'sample'}}
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/roommates' do
    post 'Create a Roommates' do
      tags 'Roommates'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :roommate, in: :body, schema: {
        type: :object,
        properties: { roommate: { type: :object, properties: roommate_properties } },
        required: [:roommate],
      }
      response '200', 'Post created' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:roommate) { { friend_id: 1 } }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, 'Roommate is added successfully', 'roommate')
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:roommate) { { friend_id: 0 } }
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/roommates/{id}' do
    delete 'Remove Roommate' do
      tags 'Roommates'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'Roommate is removed successfully' do
        let(:'Authorization') { 'Bearer ' + generate_token }
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
