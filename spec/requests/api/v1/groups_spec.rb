require 'swagger_helper'

RSpec.describe 'api/v1/groups', type: :request do

  properties = { id: {type: :integer}, owner: {type: :object}, users: {type: :array, items: {type: :object}}}
  create_user_attributes = [{ user_id: 1, _destroy: false}, { user_id: 2, _destroy: false}]
  update_user_attributes = [{ id:  1, user_id: 1, _destroy: false}, { id:  2, user_id: 2, _destroy: false}]

  group_properties = {
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
    groups_users_attributes: {
      type: :array,
      items: {
        type: :object,
        properties: {
          id: { type: :integer },
          user_id: { type: :integer },
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

      response '200', 'Groups list' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:group) { { name: 'sample', groups_users_attributes: create_user_attributes } }
        schema type: :object, properties: ApplicationMethods.success_plural_schema(properties)
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
        properties: { group: { type: :object, properties: group_properties } },
        required: [:group],
      }

      response '200', 'Group created' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:group) { { name: 'sample', groups_users_attributes: create_user_attributes } }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, 'Group is created successfully')
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
        properties: { group: { type: :object, properties: group_properties } },
        required: [:group],
      }

      response '200', 'Group created' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:group) { { name: 'sample', groups_users_attributes: update_user_attributes} }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, 'Group is updated successfully')
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
        schema type: :object, properties: ApplicationMethods.success_schema(properties)
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
        run_test!
      end

      response '422', 'Invalid Request' do
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end
end