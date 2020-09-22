require 'swagger_helper'

RSpec.describe 'api/v1/support_tickets', type: :request do
  path '/api/v1/support_tickets' do
    post 'Raise a support ticket' do
      tags 'Contact us'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :support_ticket, in: :body, schema: {
        type: :object,
        properties:{
            reason: { type: :string },
            name: { type: :string },
            email: { type: :string },
            phone: { type: :string },
            message: { type: :string }
        }
      }

      response '200', 'like created' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        run_test!
      end

      response '422', 'Invalid Request' do
        run_test!
      end
    end
  end

end
