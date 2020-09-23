require 'swagger_helper'

RSpec.describe 'api/v1/followers', type: :request do
  properties = {
    id: { type: :integer },
    follower: { type: :object },
    following: { type: :object },
  }

  path '/api/v1/followers' do
    get 'List of Followers' do
      tags 'Followers'
      security [Bearer: []]
      parameter name: :per, in: :query, type: :integer, value: Kaminari.config.default_per_page
      parameter name: :page, in: :query, type: :integer, value: 1

      response '200', 'List of Followers' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_plural_schema(properties, nil, 'follow')
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:follower) {{}}
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

end
