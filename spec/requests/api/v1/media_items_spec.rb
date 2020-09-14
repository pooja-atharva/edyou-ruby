require 'swagger_helper'

RSpec.describe 'api/v1/media_items', type: :request do
  attributes = {
    token: {type: :string}
  }
  path '/api/v1/media_items' do
    post 'Upload Media Items' do
      tags 'Media Items'
      security [Bearer: []]
      parameter name: :media_items, in: :formData, type: :file, required: true
      response '200', 'Image is added successfully in event' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_schema(attributes, 'Image is added successfully in event', 'media_item')
        run_test!
      end
      response "422", 'invalid request' do
        run_test!
      end
    end
  end
end