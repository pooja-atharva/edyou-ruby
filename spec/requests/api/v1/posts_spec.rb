require 'swagger_helper'

RSpec.describe 'api/v1/posts', type: :request do

  properties = { id: {type: :integer}, body: {type: :string},
                  publish_date: {type: :string},
                  parent: { type: :object},
                  feeling: { type: :string },
                  activity: { type: :string },
                  permission: { type: :object },
                  status: { type: :integer},
                  delete_post_after_24_hour: { type: :boolean },
                  access_requirement_ids: { type: :array,
                                            items: { type: :integer } },
                  tagged_users: {type: :array, items: {type: :object}},
                  users: {type: :array, items: {type: :object}}}

  audience_properties = { id: {type: :integer}, action_name: {type: :string},
                            action_description: {type: :string},
                            action_emoji: {type: :string},
                            action: {type: :string},
                            action_object: {type: :string} }

  post_properties = {
    body: { type: :string },
    publish_date: { type: :string, format: "date-time" },
    parent_id: { type: :integer },
    parent_type: { type: :string },
    feeling_id: { type: :integer },
    activity_id: { type: :integer },
    permission_id: { type: :integer },
    delete_post_after_24_hour: { type: :boolean },
    status: { type: :integer },
    access_requirement_ids: { type: :array, items: { type: :integer } },
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

  path '/api/v1/posts/audience' do
    get 'List Post Permission' do
      tags 'Posts'
      security [Bearer: []]
      consumes 'application/json'

      response '200', 'Posts list permissions' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:post) { { name: 'sample' } }
        schema type: :object, properties: ApplicationMethods.success_plural_schema(audience_properties)
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:post) {{name: 'sample', user_ids: [1,2]}}
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end
end
