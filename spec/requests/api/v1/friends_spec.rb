require 'swagger_helper'

RSpec.describe 'api/v1/friends', type: :request do

  properties = { id: {type: :integer}, name: {type: :string}}

  path '/api/v1/friends' do
    get 'Get User Friends' do
      tags 'Friends'
      security [Bearer: []]
      consumes 'application/json'

      response '200', 'Friends list' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:friend) { { name: 'sample' } }
        schema type: :object, properties: ApplicationMethods.success_plural_schema(properties)
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:friend) {{name: 'sample'}}
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/friends/search' do
    post 'Get User Friends Search Result' do
      tags 'Friends'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :query, in: :path, type: :string

      response '200', 'Album created' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:friends) { { name: 'sample' } }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, 'Friends search is successfull.')
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:friend) { { name: 'sample' } }
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end
end
