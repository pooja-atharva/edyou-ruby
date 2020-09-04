module Api
  module V1
    class CalendarEventSerializer < ActiveModel::Serializer
      include Rails.application.routes.url_helpers
      attributes :id, :title, :description, :datetime_at, :user, :status, :media_items

      def user
        ActiveModelSerializers::SerializableResource.new(
          object.user, serializer: Api::V1::UserSerializer
        )
      end

      def media_items
        object.media_items.collect{|image| { id: image.id, url: rails_blob_url(image) }}
      end
    end
  end
end
