require 'swagger_helper'

RSpec.describe 'api/v1/albums', type: :request do
  properties = { id: { type: :integer }, name: { type: :string },
                  description: { type: :string }, user: { type: :object },
                  permission: { type: :object },
                  access_requirement_ids: { type: :array,
                                            items: { type: :integer } },
                  allow_contributors: { type: :boolean },
                  contributors: { type: :object },
                  post_count: { type: :integer }
                }
  audience_properties = { id: {type: :integer}, action_name: {type: :string},
                            action_description: {type: :string},
                            action_emoji: {type: :string},
                            action: {type: :string},
                            action_object: {type: :string} }

  album_properties = {
    name: { type: :string },
    description: { type: :string },
    permission_id: { type: :integer },
    access_requirement_ids: { type: :array, items: { type: :integer } },
    allow_contributors: { type: :boolean },
    contributors_attributes: {
      type: :array,
      items: {
        type: :object,
        properties: {
          id: { type: :integer },
          user_id: { type: :integer }
        }
      }
    }
  }

  path '/api/v1/albums' do
    get 'Get User Albums' do
      tags 'Albums'
      security [Bearer: []]
      consumes 'application/json'

      response '200', 'Albums list' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:album) { { name: 'sample' } }
        schema type: :object, properties: ApplicationMethods.success_plural_schema(properties)
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:album) { { name: 'sample' } }
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/albums' do
    post 'Create an Album' do
      tags 'Albums'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :album, in: :body, schema: {
        type: :object,
        properties: { album: { type: :object, properties: album_properties } },
        required: [:album],
      }

      response '200', 'Album created' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:album) { { name: 'sample'} }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, 'Album is created successfully')
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:album) { { name: 'sample' }}
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/albums/audience' do
    get 'List Album Permission' do
      tags 'Albums'
      security [Bearer: []]
      consumes 'application/json'

      response '200', 'Albums list permissions' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:album) { { name: 'sample' } }
        schema type: :object, properties: ApplicationMethods.success_plural_schema(audience_properties)
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:album) {{name: 'sample', user_ids: [1,2]}}
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end
end
