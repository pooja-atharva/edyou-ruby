require 'swagger_helper'

RSpec.describe 'api/v1/likes', type: :request do
  path '/api/v1/likes' do
    post 'like a post' do
      tags 'Likes'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :like, in: :body, schema: {
        type: :object,
        properties:{
            id: { type: :integer }
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

  path '/api/v1/likes/{id}' do
    delete 'unlike a post' do
      tags 'Likes'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'Post ID'
      response '200', 'unliked' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        run_test!
      end

      response '401', 'Unauthorized' do
        run_test!
      end

      response '422', 'Invalid Request' do
        run_test!
      end
    end
  end

end
