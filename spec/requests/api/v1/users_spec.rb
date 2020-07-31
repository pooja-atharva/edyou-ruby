require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
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
        let(:reset_password) { { reset_password_token: 'token', password: 'password' } }
        run_test!
      end
      response "422", 'invalid request' do
        let(:reset_password) {{reset_password_token: 'token', password: 'password'}}
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
        schema type: :object, properties: { email: 'email'}
        run_test!
      end
      response "422", 'invalid request' do
        schema type: :object, properties: { email: 'email'}
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
        schema type: :object, properties: { email: 'email', otp: 'OTP'}
        run_test!
      end
      response "422", 'invalid request' do
        schema type: :object, properties: { email: 'email', otp: 'OTP'}
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
        let(:user) { { name: 'name', email: 'email', password: 'password' } }
        run_test!
      end
      response "422", 'invalid request' do
        let(:user) { { name: 'name', email: 'email', password: 'password' } }
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
        let(:user) { { email: 'email', password: 'password', grant_type: 'password' } }
        run_test!
      end
      response "422", 'invalid request' do
        let(:user) { { email: 'email', password: 'password', grant_type: 'password' } }
        run_test!
      end
    end
  end
end
