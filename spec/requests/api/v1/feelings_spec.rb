require 'swagger_helper'

RSpec.describe 'api/v1/feelings', type: :request do

  properties = { id: {type: :integer}, name: {type: :string}}

  path '/api/v1/feelings' do
    get 'Get Feelings List' do
      tags 'Feelings'
      security [Bearer: []]
      consumes 'application/json'

      response '200', 'Feelings list' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:feeling) { { name: 'sample' } }
        schema type: :object, properties: ApplicationMethods.success_plural_schema(properties)
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:feeling) {{name: 'sample'}}
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end
end
