require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  properties = {
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
  }

  user_properties = {
    type: :array,
    items: {
      type: :object,
      properties: { id: { type: :integer }, email: { type: :string }, name: { type: :string }, profile_image: { type: :string } }
    }
  }
  base_response = {
    status: { type: :boolean, example: true },
    message: { type: :string, example: '' },
    data: { type: :object,  properties: { your_college: user_properties, other_school_users: user_properties } }
  }

  path '/api/v1/users' do
    get 'Get User Users' do
      tags 'Users'
      security [Bearer: []]
      parameter name: :query, in: :query, type: :string, value: 'string'
      parameter name: :per, in: :query, type: :integer, value: Kaminari.config.default_per_page
      parameter name: :page, in: :query, type: :integer, value: 1
      parameter name: :section_type, in: :query, type: :string, value: 'school_users', enum: Constant::SECTION_OBJECTS

      response '200', 'Users list' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: base_response.merge(ApplicationMethods.meta_tags_schema).merge(errors: {type: :array, items: { type: :string}})
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:album) { { name: 'sample' } }
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/users/reset_password' do
    post 'Reset User Password' do
      tags 'Auth'
      consumes 'application/json'
      parameter name: :reset_password, in: :body, schema: {
        type: :object,
        properties: {
            reset_password_token: { type: :string },
            password: { type: :string }
        },
        required: [:reset_password_token, :password],
      }
      response '200', 'Reset User Password done' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        run_test!
      end
      response "422", 'invalid request' do
        run_test!
      end
    end
  end

  path '/api/v1/users/send_otp' do
    post 'Send OTP' do
      tags 'Auth'
      parameter name: :email, in: :formData, type: :string, required: true
      response '200', 'User created successfully' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        run_test!
      end
      response "422", 'invalid request' do
        run_test!
      end
    end
  end

  path '/api/v1/users/google' do
    post 'Google signin' do
      tags 'Auth'
      consumes 'application/json'
      parameter name: :google, in: :body, schema: {
        type: :object,
        properties: {
            access_token: { type: :string }
        },
        required: [:access_token],
      }
      response '200', 'Login Successful' do
        run_test!
      end
      response "422", 'invalid request' do
        run_test!
      end
    end
  end

  path '/api/v1/users/update' do
    put 'Update User Profile' do
      tags 'Profile'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
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
          favourite_quotes: { type: :string }
        },
      }
      response '200', 'User profile updated successfully' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        run_test!
      end
      response "422", 'invalid request' do
        run_test!
      end
    end
  end

  path '/api/v1/users/profile_image' do
    post 'Update Profile Pic' do
      tags 'Profile'
      security [Bearer: []]
      parameter name: :profile_image, in: :formData, type: :file, required: true
      response '200', 'Profile pic uploaded successfully' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        run_test!
      end
      response "422", 'invalid request' do
        run_test!
      end
    end
  end

  path '/api/v1/users/verify_otp' do
    post 'Verify OTP' do
      tags 'Auth'
      parameter name: :email, in: :formData, type: :string, required: true
      parameter name: :otp, in: :formData, type: :string, required: true
      response '200', 'User created successfully' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        run_test!
      end
      response "422", 'invalid request' do
        run_test!
      end
    end
  end

  path '/api/v1/users/signup' do
    post 'Create User' do
      tags 'Auth'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string },
          password: { type: :string }
        },
        required: [:name, :email, :password],
      }
      response '200', 'User created successfully' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        run_test!
      end
      response "422", 'invalid request' do
        run_test!
      end
    end
  end

  path '/oauth/token' do
    post 'Login' do
      tags 'Auth'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string },
          grant_type: { type: :string, example: 'password' }
        },
        required: [:email, :password, :grant_type],
      }
      response '200', 'Login' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        run_test!
      end
      response "422", 'invalid request' do
        run_test!
      end
    end
  end

  path '/api/v1/users/device_token' do
    post 'Add device token' do
      tags 'Auth'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :device, in: :body, schema: {
        type: :object,
        properties:{
            token: { type: :string },
            device_type: { type: :integer }
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

  path '/api/v1/users/{id}' do
    get 'User Profile' do
      tags 'Profile'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'User ID'

      response '200', 'User Profile' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, nil, 'user')
        run_test!
      end

      response '422', 'Invalid Request' do
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/users/me' do
    get 'Current User Profile' do
      tags 'Profile'
      security [Bearer: []]
      consumes 'application/json'
      response '200', 'Current User Profile' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_schema(properties.except(:friend_status), nil, 'user')
        run_test!
      end

      response '422', 'Invalid Request' do
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end
end
