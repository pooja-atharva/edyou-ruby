require 'swagger_helper'

RSpec.describe 'api/v1/blocks', type: :request do
  properties = {
    id: { type: :integer },
    type: { type: :string },
    block: { type: :object }
  }
 
  path '/api/v1/blocks' do
    get 'List of Blocks' do
      tags 'Blocks'
      security [Bearer: []]
      parameter name: :per, in: :query, type: :integer, value: Kaminari.config.default_per_page
      parameter name: :page, in: :query, type: :integer, value: 1
      parameter name: :reference_type, in: :query, type: :string, value: "User", enum: ["User", 'Post', 'Group']

      response '200', 'List of Followings' do
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

  path '/api/v1/blocks' do
    post 'Block' do
      tags 'Blocks'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :block, in: :body, schema: {
        type: :object,
        properties:{
          reference_type: { type: :string, value: "User", enum: ["User", 'Post', 'Group']},
          reference_id: { type: :integer }
        },
        required: [:reference_type, :reference_id],
      }

      response '200', 'Follow user' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        let(:block) { { id: 1 } }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, 'You have blocked succesfully')
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:follower) {{id: 0}}
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/blocks' do
    delete 'Unblock' do
      tags 'Blocks'
      security [Bearer: []]
      consumes 'application/json'
      parameter name: :block, in: :body, schema: {
        type: :object,
        properties:{
          reference_type: { type: :string, value: "User", enum: ["User", 'Post', 'Group']},
          reference_id: { type: :integer }
        },
        required: [:reference_type, :reference_id],
      }

      response '200', 'Unblock' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, 'You have unblocked succesfully')
        run_test!
      end

      response '401', 'Unauthorized' do
        schema type: :object, properties: ApplicationMethods.unauthorized_schema
        run_test!
      end

      response '422', 'Invalid Request' do
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end
end  