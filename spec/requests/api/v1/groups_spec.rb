require 'swagger_helper'

RSpec.describe 'api/v1/groups', type: :request do

  properties = {
    id: { type: :integer },
    name: { type: :string },
    privacy: { type: :boolean},
    university: { type: :string},
    section: { type: :string},
    president: { type: :string},
    vice_president: { type: :string},
    treasure: { type: :string},
    social_director: { type: :string},
    secretary: { type: :string},
    email: { type: :string},
    calendar_link: { type: :string},
    users_count: {type: :integer},
    friends_count: {type: :integer},
    users: { type: :array, items: {type: :object} },
    owner: { type: :object },
    groups_users: {
      type: :array,
      items: {
        type: :object,
        properties: {
          id: { type: :integer },
          user: { type: :object },
        }
      }
    }
  }
  create_user_attributes = [{ user_id: 1, admin: true}, { user_id: 2, admin: false }]
  update_user_attributes = [{ id:  1, user_id: 1, admin: true, _destroy: false}, { id:  2, user_id: 2, admin: false, _destroy: false}]

  create_group_properties = {
    name: { type: :string },
    description: { type: :string },
    privacy: { type: :boolean},
    university: { type: :string},
    section: { type: :string},
    president: { type: :string},
    vice_president: { type: :string},
    treasure: { type: :string},
    social_director: { type: :string},
    secretary: { type: :string},
    email: { type: :string},
    calendar_link: { type: :string},
    avatar: {
      type: :object,
      properties: {
          data: {type: :string, example: 'data:image/png;base64,base64 data'}
      }
    },
    groups_users_attributes: {
      type: :array,
      items: {
        type: :object,
        properties: {
          user_id: { type: :integer },
          admin: {type: :boolean}
        }
      }
    }
  }

  update_group_properties = {
    name: { type: :string },
    description: { type: :string },
    privacy: { type: :boolean},
    university: { type: :string},
    section: { type: :string},
    president: { type: :string},
    vice_president: { type: :string},
    treasure: { type: :string},
    social_director: { type: :string},
    secretary: { type: :string},
    email: { type: :string},
    calendar_link: { type: :string},
    avatar: {
      type: :object,
      properties: {
        data: {type: :string, example: 'data:image/png;base64,base64 data'}
      }
    },
    groups_users_attributes: {
      type: :array,
      items: {
        type: :object,
        properties: {
          id: { type: :integer },
          user_id: { type: :integer },
          admin: {type: :boolean},
          _destroy: { type: :boolean }
        }
      }
    }
  }

  path '/api/v1/groups' do
    get 'Get User Groups' do
      tags 'Groups'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :per, in: :query, type: :integer, value: Kaminari.config.default_per_page
      parameter name: :page, in: :query, type: :integer, value: 1


      response '200', 'Groups list' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:group) { { name: 'sample', groups_users_attributes: create_user_attributes } }
        schema type: :object, properties: ApplicationMethods.success_plural_schema(properties, '', 'groups')
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:group) {{name: 'sample', user_ids: [1,2]}}
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/groups' do
    post 'Create an Group' do
      tags 'Groups'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :group, in: :body, schema: {
        type: :object,
        properties: { group: { type: :object, properties: create_group_properties } },
        required: [:group],
      }

      response '200', 'Group is created' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:group) { { name: 'sample', groups_users_attributes: create_user_attributes } }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, 'Group is created successfully', 'group')
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:group) { { name: 'sample', groups_users_attributes: update_user_attributes} }
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/groups/{id}/' do
    put 'Update Group Details' do
      tags 'Groups'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'Group ID'
      parameter name: :group, in: :body, schema: {
        type: :object,
        properties: { group: { type: :object, properties: update_group_properties } },
        required: [:group],
      }

      response '200', 'Group is updated' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:group) { { name: 'sample', groups_users_attributes: update_user_attributes} }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, 'Group is updated successfully', 'group')
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:group) { { name: 'sample', groups_users_attributes: update_user_attributes} }
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/groups/{id}/status' do
    put 'Update Group status' do
      tags 'Groups'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'Group ID'
      parameter name: :group, in: :body, schema: {
        type: :object,
        properties: { group: { type: :object, properties: { status: {type: :string, enum: %w(active in_active)}} } },
        required: [:group],
      }

      response '200', 'Group is updated' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:group) { { name: 'sample', groups_users_attributes: update_user_attributes} }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, 'Group is active/hide now', 'group')
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:group) { { name: 'sample', groups_users_attributes: update_user_attributes} }
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/groups/{id}' do
    get 'Group Details' do
      tags 'Groups'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'Group ID'

      response '200', 'Group Details' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, nil, 'group')
        run_test!
      end

      response '422', 'Invalid Request' do
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/groups/{id}' do
    delete 'Leave Group' do
      tags 'Groups'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'Group ID'

      response '200', 'Group removed successfully' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: { status: { type: :boolean, example: true }, message: { type: :string, example: 'Group is left successfully.' }}
        run_test!
      end

      response '422', 'Invalid Request' do
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/groups/{id}/remove_avatar' do
    delete 'Remove Group Avatar' do
      tags 'Groups'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'Group ID'

      response '200', 'Group avatar removed successfully' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, 'Group Avatar is removed.', 'group')
        run_test!
      end

      response '422', 'Invalid Request' do
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/groups/{id}/join' do
    post 'Join Group' do
      tags 'Groups'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'Group Id'
      parameter name: :status, in: :query, type: :string, description: 'status', enum: %w(approved declined)

      response '200', 'Join Group' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:group) { { name: 'sample', groups_users_attributes: create_user_attributes } }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, 'Group request is approved/ Group request is declined', 'group')
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:group) { { name: 'sample', groups_users_attributes: update_user_attributes} }
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

end
