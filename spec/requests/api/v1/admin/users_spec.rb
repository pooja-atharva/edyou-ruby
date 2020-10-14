require 'swagger_helper'

RSpec.describe 'api/v1/admin/users', type: :request do
  properties = {
    id: { type: :integer },
    email: { type: :string },
    name: { type: :string },
    profile_image: { type: :string },
    blocked: {type: :boolean}
  }

  user_profile_properties = {
    id: { type: :integer },
    user_id: { type: :integer },
    email: { type: :string },
    name: { type: :string },
    class_name: { type: :string },
    graduation: { type: :string },
    status: { type: :string },
    attending_university: { type: :string },
    high_school: { type: :string },
    from_location: { type: :string },
    country: { type: :string },
    gender: { type: :string },
    religion: { type: :string },
    language: { type: :string },
    date_of_birth: { type: :string },
    favourite_quotes: { type: :string },
    friend_status: { type: :string },
    is_following: { type: :boolean },
    is_blocked: { type: :boolean },
    blocked: { type: :boolean }
  }

  path '/api/v1/admin/users/{id}' do
    get 'User Profile' do
      tags 'Admin Users'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'User ID'

      response '200', 'User Profile' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_schema(user_profile_properties, nil, 'user')
        run_test!
      end

      response '422', 'Invalid Request' do
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/admin/users/{id}' do
    put 'Update User' do
      tags 'Admin Users'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'User ID'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              blocked: { type: :boolean }
            }
          }
        },
        required: [:user],
      }

      response '200', 'Update user' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, 'You have blocked succesfully', 'user')
        run_test!
      end

      response '422', 'Invalid Request' do
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end
end
