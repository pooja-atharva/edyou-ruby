module Api
  module V1
    class CalendarEventSerializer < ActiveModel::Serializer
      include Rails.application.routes.url_helpers
      attributes :id, :title, :description, :epoc_datetime_at, :user, :status,
      :media_items, :attendance

      def user
        ActiveModelSerializers::SerializableResource.new(
          object.user, serializer: Api::V1::UserSerializer
        )
      end

      def media_items
        object.media_items.collect{|image| { id: image.id, url: rails_blob_url(image) }}
      end

      def epoc_datetime_at
        object.datetime_at.to_i rescue nil
      end

      def attendance
        default = Constant::EVENT_ATTENDANCE_STATUS.to_h{|item| [item, 0]}
        default.merge(object.event_attendances.group(:status).count).slice(*Constant::EVENT_ATTENDANCE_STATUS)
      end
    end
  end
end
