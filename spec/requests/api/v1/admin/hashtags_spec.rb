require 'swagger_helper'

RSpec.describe 'api/v1/admin/hashtags', type: :request do
  properties = {
    id: { type: :integer },
    context: { type: :string },
  }

  hashtag_properties = {
    context: { type: :string }
  }

  path '/api/v1/admin/hashtags' do
    post 'Create Hashtag' do
      tags 'Admin Hashtag'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :hashtag, in: :body, schema: {
        type: :object,
        properties: { hashtag: { type: :object, properties: hashtag_properties } },
        required: [:hashtag],
      }
      response '200', 'Hashtag' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, nil, 'hashtag')
        run_test!
      end

      response '422', 'Invalid Request' do
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

end
