require 'swagger_helper'

RSpec.describe 'api/v1/posts', type: :request do

  properties = { id: {type: :integer}, body: {type: :string},
                  publish_date: {type: :string},
                  parent_id: { type: :integer}, parent_type: { type: :string },
                  feeling: { type: :string },
                  activity: { type: :string },
                  tagged_users: {type: :array, items: {type: :object}},
                  users: {type: :array, items: {type: :object}}}

  post_properties = {
    body: { type: :string },
    publish_date: { type: :string, format: "date-time" },
    parent_id: { type: :integer },
    parent_type: { type: :string },
    feeling_id: { type: :integer },
    activity_id: { type: :integer },
    taggings_attributes: {
      type: :array,
      items: {
        type: :object,
        properties: {
          id: { type: :integer },
          tagger_id: { type: :integer },
          tagger_type: { type: :string}
        }
      }
    }
  }

  path '/api/v1/posts' do
    post 'Create a Post' do
      tags 'Posts'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :post, in: :body, schema: {
        type: :object,
        properties: { post: { type: :object, properties: post_properties } },
        required: [:post],
      }
      response '200', 'Post created' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:post) { { body: 'sample' } }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, 'Post is created successfully')
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:post) { { body: 'sample' } }
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end
end
