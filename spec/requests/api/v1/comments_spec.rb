require 'swagger_helper'

RSpec.describe 'api/v1/comments', type: :request do
    path '/api/v1/comments' do
        post 'comment on a post' do
          tags 'Comments'
          security [Bearer: []]
          consumes 'application/json'
          parameter name: :comment, in: :body, schema: {
            type: :object,
            properties:{
                id: { type: :integer },
                content: { type: :string }
            }
          }
    
          response '200', 'comment created' do
            let(:'Authorization') { 'Bearer ' + generate_token }
            run_test!
          end
    
          response '422', 'Invalid Request' do
            run_test!
          end
        end
      end
end
