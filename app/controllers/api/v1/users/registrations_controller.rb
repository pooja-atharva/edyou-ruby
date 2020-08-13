# frozen_string_literal: true

module Api
  module V1
    module Users
      class RegistrationsController < Devise::RegistrationsController
        include ApplicationMethods
        skip_before_action :verify_authenticity_token

        respond_to :json

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
