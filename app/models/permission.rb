class Permission < ApplicationRecord

  scope :post_permissions, -> { where(action_object: 'Post') }
end
