require 'swagger_helper'

RSpec.describe 'api/v1/locations', type: :request do

  properties = { id: {type: :integer}, name: {type: :string}, avatar_url: {type: :string} }

  path '/api/v1/locations' do
    get 'Get Location' do
      tags 'Locations'
      security [Bearer: []]
      consumes 'application/json'

      response '200', 'Locations list' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:location) { { name: 'sample' } }
        schema type: :object, properties: ApplicationMethods.success_plural_schema(properties)
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:location) {{name: 'sample'}}
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/locations/search' do
    post 'Get Location Search Result' do
      tags 'Locations'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :query, in: :path, type: :string

      response '200', 'Album created' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:locations) { { name: 'sample' } }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, 'Locations search is successfull.')
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:location) { { name: 'sample' } }
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end
end
