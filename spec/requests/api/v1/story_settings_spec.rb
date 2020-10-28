require 'swagger_helper'

RSpec.describe 'api/v1/story_settings', type: :request do
  properties = {
    id: { type: :integer },
    share_public_story: { type: :boolean },
    share_mentioned_story: { type: :boolean },
    user: { type: :integer }
  }
 
  path '/api/v1/story_settings' do
    get 'List of story_settings' do
      tags 'Story Setting'
      security [Bearer: []]

      response '200', 'List of story_settings' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_plural_schema(properties, nil, 'story_settings')
        run_test!
      end

      response '422', 'Invalid Request' do
        let(:block) {{}}
        schema '$ref' => '#/components/schemas/errors_object'
        run_test!
      end
    end
  end

  path '/api/v1/story_settings' do
    post 'Change story Setting' do
      tags 'Story Setting'
      security [Bearer: []] 
      consumes 'application/json'
      parameter name: :story_settings, description: 'array of objects', in: :body, schema: { 
        type: :object,
        properties: {
          story_setting: {
            type: :object,
            properties: {
              share_public_story: { type: :boolean },
              share_mentioned_story: { type: :boolean }
            }
          }
        }
      }

      response '200', 'story Setting Updated' do
        let(:'Authorization') { 'Bearer ' + generate_token }
        schema type: :object, properties: ApplicationMethods.success_schema(properties, 'Story Setting is updated successfully', 'story_settings')
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