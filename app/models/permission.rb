class Permission < ApplicationRecord
  has_many :albums
  has_many :posts
  belongs_to :permission_type

  scope :post_permissions, -> { where(action_object: 'Post') }
  scope :album_permissions, -> { where(action_object: 'Album') }

  def self.include_permission_type
    joins(" right outer join permission_types on permissions.permission_type_id = permission_types.id ")
  end
end
