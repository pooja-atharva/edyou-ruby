class PrivacySetting < ApplicationRecord
  belongs_to :user
  belongs_to :permission_type
end
