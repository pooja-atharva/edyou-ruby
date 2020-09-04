module ApplicationMethods
  extend ActiveSupport::Concern

  included do
    around_action :handle_exceptions
  end

  private

  def handle_exceptions
    begin
      yield
    rescue ArgumentError => e
      @status = 400
    rescue StandardError => e
      @status = 500
    end
    detail = { detail: e.try(:message) }
    detail.merge!(trace: e.try(:backtrace)) if Rails.env.development?
    json_response({ success: false, message: e.class.to_s, errors: [detail] }, @status) unless e.class == NilClass
  end

  def render_unprocessable_entity_response(resource, _status = 200)
    json_response({
                    success: false,
                    message: ValidationErrorsSerializer.new(resource).serialize[0][:message],
                    errors: ValidationErrorsSerializer.new(resource).serialize
                  }, 200)
  end

  def render_unprocessable_entity(message, status = 422)
    json_response({
      success: false,
      message: message
    }, status) and return true
  end

  def render_success_response(resources = {}, message = '', status = 200, meta = {})
    json_response({
                    success: true,
                    message: message,
                    data: resources,
                    meta: meta
                  }, status)
  end

  def json_response(options = {}, status = 500)
    render json: JsonResponse.new(options), status: status
  end

  def render_unauthorized_response
    json_response({
                    success: false,
                    message: 'You are not authorized.'
                  }, 401)
  end

  def doorkeeper_unauthorized_render_options(error: nil)
    { json: { status: false, message: 'You are not authorized.' } }
  end

  def array_serializer
    ActiveModel::Serializer::CollectionSerializer
  end

  def single_serializer
    ActiveModelSerializers::SerializableResource
  end

  def self.success_schema(properties = {}, message = nil, data_key = 'model_key')
    {
      status: { type: :boolean, example: true }, message: { type: :string, example: message },
      data: {
        type: :object, properties: {
          "#{data_key}": { type: :object, properties: properties }
        }
      }
    }
  end

  def self.success_plural_schema(properties = {}, message = nil, data_key = 'model_key', meta_tags = true)
    base_response = {
      status: { type: :boolean, example: true }, message: { type: :string, example: message },
      data: {
        type: :object,  properties: {
          "#{data_key}": { type: :array, items:{ properties: properties}  }
        }
      },
    }
    base_response.merge!(meta_tags_schema) if meta_tags
    base_response.merge(errors: {type: :array, items: { type: :string}})
  end

  def self.invalid_schema
    {
      status: { type: :boolean, example: false }, message: { type: :string },
      errors: { type: :array, items: { type: :string}}
    }
  end

  def self.meta_tags_schema
    {
      meta: { type: :object, properties: {
        page: {type: :string},
        per: {type: :string},
        pagination: {type: :object, properties: {
          per_page: {type: :integer, example: Kaminari.config.default_per_page},
          current_page: {type: :integer, example: 1},
          next_page: {type: :integer, example: 2},
          prev_page: {type: :integer, example: 0},
          total_pages: {type: :integer, example: 2},
          total_count: {type: :integer, example: Kaminari.config.default_per_page * 2},
        }},
      }}
    }
  end

  def self.unauthorized_schema
    {
      status: { type: :boolean, example: false },
      message: { type: :string, example: 'You are not authorized.' }
    }
  end
end
