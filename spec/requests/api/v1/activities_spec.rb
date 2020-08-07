require 'swagger_helper'

RSpec.describe 'api/v1/activities', type: :request do

  properties = { id: {type: :integer}, name: {type: :string},
                  parent: {type: :string}}

  path '/api/v1/activities' do
    get 'Get Activities List' do
      tags 'Activities'
      security [Bearer: []]
      consumes 'application/json'

      response '200', 'Activities list' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:activity) { { name: 'sample' } }
        schema type: :object, properties: ApplicationMethods.success_plural_schema(properties)
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:activity) {{name: 'sample'}}
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end
end
