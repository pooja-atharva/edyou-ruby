require 'swagger_helper'

RSpec.describe 'api/v1/privacy_settings', type: :request do
  properties = {
    id: { type: :integer },
    action_object: { type: :string },
    permission_type: { type: :object },
    user: { type: :object }
  }
  privacy_setting_properties = {
    permission_type_id: { type: :integer }
  }
 
  path '/api/v1/privacy_settings' do
    get 'List of privacy_settings' do
      tags 'Privacy Setting'
      security [Bearer: []]

      response '200', 'List of privacy_settings' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_plural_schema(properties)
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:block) {{}}
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/privacy_settings/{id}' do
    put 'Update Privacy Setting' do
      tags 'Privacy Setting'
      security [Bearer: []] 
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'Privacy Setting ID'
      parameter name: :privacy_setting, in: :body, schema: {
        type: :object,
        properties: {
          privacy_setting: {
            type: :object,
            properties: {
              permission_type_id: { type: :integer }
            }
          }
        },
        required: [:privacy_setting],
      }

      response '200', 'Privacy Setting Updated' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, 'Privacy Setting is updated successfully')
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