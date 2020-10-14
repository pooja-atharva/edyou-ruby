require 'swagger_helper'

RSpec.describe 'api/v1/chatroom_users', type: :request do
  path '/api/v1/chatroom_users/add_participants' do
    post 'add participants' do
      tags 'Chatroom User'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :chatroom, in: :body, schema: {
        type: :object,
        properties:{
            chatroom_id: { type: :integer },
            user_ids: { type: :array, items: { type: :integer } }
        }
      }

      response '200', 'Success' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        run_test!
      end

      response '422', 'Invalid Request' do
        run_test!
      end
    end
  end

  path '/api/v1/chatroom_users/delete_participant' do
    post 'delete participant' do
      tags 'Chatroom User'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :chatroom, in: :body, schema: {
        type: :object,
        properties:{
            chatroom_id: { type: :integer },
            user_id: { type: :integer },
        }
      }

      response '200', 'Success' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        run_test!
      end

      response '422', 'Invalid Request' do
        run_test!
      end
    end
  end

  path '/api/v1/chatroom_users/add_admin_role' do
    post 'add admin role' do
      tags 'Chatroom User'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :chatroom, in: :body, schema: {
        type: :object,
        properties:{
            chatroom_id: { type: :integer },
            user_id: { type: :integer },
        }
      }

      response '200', 'Success' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        run_test!
      end

      response '422', 'Invalid Request' do
        run_test!
      end
    end
  end

  path '/api/v1/chatroom_users/remove_admin_role' do
    post 'remove admin role' do
      tags 'Chatroom User'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :chatroom, in: :body, schema: {
        type: :object,
        properties:{
            chatroom_id: { type: :integer },
            user_id: { type: :integer },
        }
      }

      response '200', 'Success' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        run_test!
      end

      response '422', 'Invalid Request' do
        run_test!
      end
    end
  end

  path '/api/v1/chatroom_users/{chatroom_id}' do
    delete 'Leave chatroom' do
      tags 'Chatroom User'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :chatroom_id, in: :path, type: :integer

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
