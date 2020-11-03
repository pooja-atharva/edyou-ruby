require 'swagger_helper'

RSpec.describe 'api/v1/posts', type: :request do

  properties = { id: {type: :integer}, body: {type: :string},
                  publish_date: {type: :string},
                  parent: { type: :object},
                  feeling: { type: :string },
                  post_activity: { type: :string },
                  comment_count: { type: :integer },
                  like_count: { type: :integer },
                  permission: { type: :object },
                  location: {type: :object },
                  status: { type: :integer},
                  temp_post_type: { type: :string },
                  groups: {type: :object},
                  access_requirement_ids: { type: :array,
                                            items: { type: :integer } },
                  tagged_users: {type: :array, items: {type: :object}},
                  users: {type: :array, items: {type: :object}}}

  audience_properties = { id: {type: :integer}, action_name: {type: :string},
                            action_description: {type: :string},
                            action_emoji: {type: :string},
                            action: {type: :string},
                            action_object: {type: :string} }

  comment_properties = { id: {type: :integer}, content: {type: :string},
                            user: {type: :object},
                            created_at: {type: :string, format: "date-time" }}

  post_properties = {
    body: { type: :string },
    publish_date: { type: :string, format: "date-time" },
    parent_id: { type: :integer },
    parent_type: { type: :string },
    feeling_id: { type: :integer },
    activity_id: { type: :integer },
    permission_id: { type: :integer },
    location_id: { type: :integer },
    group_ids: { type: :array, items: { type: :integer } },
    temp_post_type: { type: :string },
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

  path '/api/v1/posts/{id}/comments' do
    get 'List comments of the posts' do
      tags 'Posts'
      security [Bearer: []]
      consumes 'application/json'

      response '200', 'Post comment list' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:post) { { name: 'sample' } }
        schema type: :object, properties: ApplicationMethods.success_plural_schema(comment_properties)
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:post) {{name: 'sample', user_ids: [1,2]}}
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/posts/{id}/report_post' do
    post 'Report a Post' do
      tags 'Posts'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :post, in: :body, schema: {
        type: :object,
        properties: { post: { type: :object, properties: {reason: {type: :string} } } },
        required: [:post],
      }
      response '200', 'Post reported' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:post) { { reason: 'sample' } }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, 'Post is reported successfully')
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:post) { { body: 'sample' } }
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/posts/search' do
    post 'Search Post by Hashtag' do
      tags 'Posts'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :query, in: :query, type: :string, value: 'string'
      parameter name: :page, in: :query, type: :integer, value: 1
      parameter name: :per, in: :query, type: :integer, value: Kaminari.config.default_per_page

      response '200', 'List of Posts' do
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
