class PermissionType < ApplicationRecord
  has_many :permissions
  has_many :privacy_settings
end
 