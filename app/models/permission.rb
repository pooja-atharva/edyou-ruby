class Permission < ApplicationRecord
  has_many :albums

  scope :post_permissions, -> { where(action_object: 'Post') }
  scope :album_permissions, -> { where(action_object: 'Album') }
end
