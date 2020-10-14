require 'swagger_helper'

RSpec.describe 'api/v1/direct_messages', type: :request do
  path '/api/v1/direct_messages/{id}' do
    get 'particular user chat detail' do
      tags 'Direct Message'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'Success' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        run_test!
      end

      response '422', 'Invalid Request' do
        run_test!
      end
    end
  end
end
