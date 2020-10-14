require 'swagger_helper'

RSpec.describe 'api/v1/messages', type: :request do
  path '/api/v1/messages/get_media?chatroom_id={chatroom_id}&per_page={per_page}&page={page}' do
    get 'Get all messages of particular chatroom' do
      tags 'Message'
      security [Bearer: []]
      parameter name: :chatroom_id, in: :path, type: :integer
      parameter name: :per_page, in: :path, type: :integer, value: Kaminari.config.default_per_page
      parameter name: :page, in: :path, type: :integer, value: 1

      response '200', 'Success' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        run_test!
      end

      response '422', 'Invalid Request' do
        run_test!
      end
    end
  end

  path '/api/v1/messages/{id}' do
    delete 'delete message' do
      tags 'Message'
      security [Bearer: []]
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
