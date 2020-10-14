require 'swagger_helper'

RSpec.describe 'api/v1/chatrooms', type: :request do
  path '/api/v1/chatrooms/' do
    post 'create chatroom' do
      tags 'Chatroom'
      security [Bearer: []]
      parameter name: :name, in: :query, type: :string
      parameter name: :group_image, in: :query, type: :file
      parameter name: :description, in: :query, type: :string
      #parameter name: :user_ids, in: :query, type: :array, items: {type: :integer}
      parameter name: 'user_ids[]', in: :query, type: :array, collectionFormat: :multi, items: { type: :integer }

      response '200', 'Success' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        run_test!
      end

      response '422', 'Invalid Request' do
        run_test!
      end
    end
  end

  path '/api/v1/chatrooms/' do
    put 'update chatroom' do
      tags 'Chatroom'
      security [Bearer: []]
      parameter name: :name, in: :query, type: :string
      parameter name: :group_image, in: :query, type: :file
      parameter name: :description, in: :query, type: :string

      response '200', 'Success' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        run_test!
      end

      response '422', 'Invalid Request' do
        run_test!
      end
    end
  end

  path '/api/v1/chatrooms/{id}' do
    delete 'Delete chatroom' do
      tags 'Chatroom'
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

  path '/api/v1/chatrooms/{id}/chatroom_detail' do
    get 'get chatroom detail' do
      tags 'Chatroom'
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

  path '/api/v1/chatrooms/{id}/get_media?per_page={per_page}&page={page}' do
    get 'get media detail' do
      tags 'Chatroom'
      security [Bearer: []]
      parameter name: :id, in: :path, type: :integer
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

  path '/api/v1/chatrooms/{id}/get_participants?per_page={per_page}&page={page}' do
    get 'get participants' do
      tags 'Chatroom'
      security [Bearer: []]
      parameter name: :id, in: :path, type: :integer
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

  path '/api/v1/chatrooms/users_list?per_page={per_page}&page={page}&search={search}' do
    get 'get participants' do
      tags 'Chatroom'
      security [Bearer: []]
      parameter name: :search, in: :path, type: :string, required: false
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
end
