namespace :users do
  desc 'Create default settings data'
  task default_settings: :environment do
    User.all.each do |user|
      default_permission_type_id = PermissionType.find_by(action: 'public').id
      Constant::PRIVACY_SETTING_OBJECTS.each do |ps_object|
        privacy_setting = user.privacy_settings.find_by(action_object: ps_object)
        next if privacy_setting.present?
        user.privacy_settings.find_or_create_by(permission_type_id: default_permission_type_id, action_object: ps_object)
      end

      if user.story_setting.nil?
        user.create_story_setting(share_public_story: true, share_mentioned_story: true)
      end

      Constant::NOTIFICATION_TYPE_OBJECTS.each do |ps_object|
        notification_setting = user.notification_settings.find_by(notification_type: ps_object)
        next if notification_setting.present?
        user.notification_settings.find_or_create_by(notification_type: ps_object, notify: true)
      end
    end
  end
end
