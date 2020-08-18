class Permission < ApplicationRecord
  has_many :albums
  has_many :posts
  belongs_to :permission_type

  scope :post_permissions, -> { where(action_object: 'Post') }
  scope :album_permissions, -> { where(action_object: 'Album') }
end
