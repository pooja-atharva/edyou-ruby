require 'swagger_helper'

RSpec.describe 'api/v1/post_settings', type: :request do
  properties = {
    id: { type: :integer },
    remove_datetime: { type: :string },
    user: { type: :object }
  }

  path '/api/v1/post_settings' do
    get 'List of post_settings' do
      tags 'Post Setting'
      security [Bearer: []]

      response '200', 'List of post_settings' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_plural_schema(properties, nil, 'post_settings')
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:block) {{}}
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/post_settings' do
    post 'Change Post Setting' do
      tags 'Post Setting'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :post_settings, description: 'array of objects', in: :body, schema: {
        type: :object,
        properties: {
          post_setting: {
            type: :array,
            items: {
              type: :object,
              properties: {
                remove_datetime: { type: :string },
                user: { type: :object }
              }
            }
          }
        }
      }

      response '200', 'Post Setting Updated' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, 'Post Setting is updated successfully', 'post_settings')
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
