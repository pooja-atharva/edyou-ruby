class Post < ApplicationRecord
  belongs_to :user
  belongs_to :feeling, optional: true
  belongs_to :activity, optional: true
  belongs_to :albums, optional: true, counter_cache: true

  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tagged_users, through: :taggings, source: :tagger, source_type: 'User', dependent: :destroy


  accepts_nested_attributes_for :taggings, allow_destroy: true
end
