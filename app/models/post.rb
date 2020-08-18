class Post < ApplicationRecord
  include Status

  belongs_to :user
  belongs_to :feeling, optional: true
  belongs_to :activity, optional: true
  belongs_to :parent, polymorphic: true, counter_cache: true, optional: true

  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tagged_users, through: :taggings, source: :tagger, source_type: 'User', dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :taggings, allow_destroy: true

  scope :daily_temp_post, -> { where("created_at <= ? and delete_post_after_24_hour = ? and status = ?", 1.day.ago, true, 4)}

  after_commit :create_hashtags

  def create_hashtags
    taggings.destroy_all if taggings.present?
    body.scan(/#\w+/).flatten.each do |tag|
      taggings.create(context: tag)
    end
  end

  def self.deactivate
    update_all(status: 5)
  end
end
