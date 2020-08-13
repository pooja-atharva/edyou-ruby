class Post < ApplicationRecord
  belongs_to :user
  belongs_to :feeling, optional: true
  belongs_to :activity, optional: true
  belongs_to :parent, polymorphic: true, counter_cache: true, optional: true

  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tagged_users, through: :taggings, source: :tagger, source_type: 'User', dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :taggings, allow_destroy: true
end
