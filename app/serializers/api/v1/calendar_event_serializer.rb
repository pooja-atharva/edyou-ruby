module Api
  module V1
    class CalendarEventSerializer < ActiveModel::Serializer
      include Rails.application.routes.url_helpers
      attributes :id, :title, :description, :epoc_datetime_at, :price, :location, :event_type, :status, :user,
                 :media_items, :invite, :attendance, :attendance_status, :users, :groups

      def user
        ActiveModelSerializers::SerializableResource.new( object.user, serializer: Api::V1::UserSerializer )
      end

      def media_items
        object.media_items.collect{|image| { id: image.id, url: rails_blob_url(image) }}
      end

      def epoc_datetime_at
        object.datetime_at.to_i rescue nil
      end

      def invite
        current_user = @instance_options[:current_user]
        return "No" if current_user.nil?
        object.event_attendances.find_by(user_id: current_user.id).present? ?  "Yes" : "No"
      end

      def attendance
        default = Constant::EVENT_ATTENDANCE_STATUS.to_h{|item| [item, 0]}
        default.merge(object.event_attendances.group(:status).count).slice(*Constant::EVENT_ATTENDANCE_STATUS)
      end

      def attendance_status
        current_user = @instance_options[:current_user]
        object.event_attendances.find_by(user_id: current_user.id).try(:status)
      end

      def users
        user_records = User.where(id: object.user_ids)
        ActiveModel::Serializer::CollectionSerializer.new(user_records, serializer: Api::V1::UserSerializer)
      end

      def groups
        groups_records = Group.where(id: object.group_ids)
        ActiveModel::Serializer::CollectionSerializer.new(groups_records, serializer: Api::V1::GroupSerializer)
      end
    end
  end
end
