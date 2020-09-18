
module Api
  module V1
    class ProfileSerializer < ActiveModel::Serializer
      attributes :id, :user_id, :email, :name, :class_name, :graduation, :major, :status, :attending_university,
                 :high_school, :from_location, :gender, :religion, :language, :date_of_birth, :favourite_quotes
      attribute :friend_status, if: :not_current_user?

      def email
        object.user.try(:email)
      end

      def name
        object.user.try(:name)
      end

      def friend_status
        current_user = @instance_options[:current_user]
        friend_obj  = current_user.friendships.with_user(object.user_id).last if current_user
        return 'unfriend' if current_user.nil? || friend_obj.nil? || friend_obj.unfriend?
        return friend_obj.status if friend_obj.approved? || friend_obj.friend_id == current_user.id
        'requestSent'
      end

      def not_current_user?
        current_user = @instance_options[:current_user]
        current_user.nil? ? true : (current_user.id != object.user_id)
      end
    end
  end
end
