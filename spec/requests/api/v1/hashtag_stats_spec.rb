require 'swagger_helper'

RSpec.describe 'api/v1/hashtag_stats', type: :request do
  properties = {
    id: { type: :integer },
    context: { type: :string },
    count: { type: :integer }
  }

  path '/api/v1/hashtag_stats' do
    get 'Search Hashtag Stat' do
      tags 'Hashtag Stats'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :query, in: :query, type: :string, value: 'string'
      parameter name: :per, in: :query, type: :integer, value: Kaminari.config.default_per_page
      parameter name: :page, in: :query, type: :integer, value: 1

      response '200', 'List of hashtag stats' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_plural_schema(properties)
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
