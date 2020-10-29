require 'swagger_helper'

RSpec.describe 'api/v1/notification_settings', type: :request do
  properties = {
    id: { type: :integer },
    notification_type: { type: :string },
    notify: { type: :boolean },
    user: { type: :integer }
  }
 
  path '/api/v1/notification_settings' do
    get 'List of notification_settings' do
      tags 'Notification Setting'
      security [Bearer: []]

      response '200', 'List of notification_settings' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_plural_schema(properties, nil, 'notification_settings')
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:block) {{}}
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/notification_settings' do
    post 'Change Notification Setting' do
      tags 'Notification Setting'
      security [Bearer: []] 
      consumes 'application/json'
      parameter name: :notification_type, in: :query, type: :string, description: 'notification_type', enum: Constant::NOTIFICATION_TYPE_OBJECTS
      parameter name: :notify, in: :query, type: :boolean, value: "true", description: 'notify'

      response '200', 'Notification Setting Updated' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, 'Notification Setting is updated successfully', 'notification_settings')
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