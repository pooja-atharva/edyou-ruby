require 'swagger_helper'

RSpec.describe 'api/v1/permissions', type: :request do
  properties = {
    id: { type: :integer },
    permission_type: { type: :object },
    action_object: { type: :string }
  }
 
  path '/api/v1/permissions' do
    get 'List of permissions' do
      tags 'Permissions'
      security [Bearer: []]
      parameter name: :reference_type, in: :query, type: :string, value: "Post", enum: ["Album", 'Post']

      response '200', 'List of Permissions' do
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
end