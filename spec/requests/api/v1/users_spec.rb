require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  properties = {
    class_name: { type: :string },
    graduation: { type: :string },
    status: { type: :string },
    attending_university: { type: :string },
    high_school: { type: :string },
    from_location: { type: :string },
    gender: { type: :string },
    religion: { type: :string },
    language: { type: :string },
    date_of_birth: { type: :string },
    favourite_quotes: { type: :string },
    friend_status: { type: :string }
  }

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
