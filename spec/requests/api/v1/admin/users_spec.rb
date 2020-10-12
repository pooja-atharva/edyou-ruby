require 'swagger_helper'

RSpec.describe 'api/v1/admin/users', type: :request do
  properties = {
    id: { type: :integer },
    email: { type: :string },
    name: { type: :string },
    profile_image: { type: :string }
  }
 
  path '/api/v1/admin/users' do
    get 'List of Blocked Users' do
      tags 'Admin Users'
      security [Bearer: []]
      parameter name: :per, in: :query, type: :integer, value: Kaminari.config.default_per_page
      parameter name: :page, in: :query, type: :integer, value: 1

      response '200', 'List of blocked Users' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_plural_schema(properties)
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:user) {{}}
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/admin/users/{id}' do
    put 'Block User' do
      tags 'Admin Users'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'User ID'

      response '200', 'Block user' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, 'You have blocked succesfully')
        run_test!
      end

      response '422', 'Invalid Request' do
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/admin/users/{id}' do
    delete 'Unblock User' do
      tags 'Admin Users'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'User ID'

      response '200', 'Unblock User' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, 'You have unblocked succesfully')
        run_test!
      end

      response '422', 'Invalid Request' do
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end
end