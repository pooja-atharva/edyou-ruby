require 'swagger_helper'

RSpec.describe 'api/v1/admin/posts', type: :request do
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
                  delete_post_after_24_hour: { type: :boolean },
                  groups: {type: :object},
                  access_requirement_ids: { type: :array,
                                            items: { type: :integer } },
                  tagged_users: {type: :array, items: {type: :object}},
                  users: {type: :array, items: {type: :object}}}

  path '/api/v1/admin/posts' do
    get 'Get Posts' do
      tags 'Admin Posts'
      security [Bearer: []]
      consumes 'application/json'

      parameter name: :per, in: :query, type: :integer, value: Kaminari.config.default_per_page
      parameter name: :page, in: :query, type: :integer, value: 1

      response '200', 'Posts list' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:post) { { body: 'This is test' } }
        schema type: :object, properties: ApplicationMethods.success_plural_schema(properties, '', 'posts')
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:post) { { body: 'This is test' } }
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/admin/posts/{id}' do
    get 'Get Post' do
      tags 'Admin Posts'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'Post ID'

      response '200', 'Post detail' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:post) { { body: 'This is test' } }
        schema type: :object, properties: ApplicationMethods.success_plural_schema(properties, '', 'posts')
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:post) { { body: 'This is test' } }
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/admin/posts/{id}' do
    delete 'delete post' do
      tags 'Admin Posts'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'Success' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        run_test!
      end

      response '422', 'Invalid Request' do
        run_test!
      end
    end
  end
end
