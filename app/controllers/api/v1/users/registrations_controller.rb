# frozen_string_literal: true

module Api
  module V1
    module Users
      class RegistrationsController < Devise::RegistrationsController
        include Swagger::Blocks
        include ApplicationMethods
        skip_before_action :verify_authenticity_token

        respond_to :json

        swagger_path '/api/v1/users/signup' do
          operation :post do
            key :summary, 'Create User'
            key :description, ''
            key :tags, [
              'Auth'
            ]
            parameter do
              key :name, :user
              key :in, :body
              key :required, true
              schema do
                key :'$ref', :UserInput
              end
            end
          end
        end

        swagger_path '/oauth/token' do
          operation :post do
            key :summary, 'Login'
            key :description, ''
            key :tags, [
              'Auth'
            ]
            parameter do
              key :name, :user
              key :in, :body
              key :required, true
              schema do
                key :'$ref', :UserLogin
              end
            end
          end
        end

        def create
          build_resource(sign_up_params)
          if resource.save
            Doorkeeper::AccessToken.create!(resource_owner_id: resource.id)
            render_success_response({
                                      user: single_serializer.new(resource, serializer: UserSerializer),
                                      token: Doorkeeper::AccessToken.where(resource_owner_id: resource.id).last.token
                                    })
          else
            render_unprocessable_entity_response(resource)
          end
        end

        private

        def sign_up_params
          params.permit(:email, :password, :name)
        end
      end
    end
  end
end
