class Post < ApplicationRecord
  include Status
  include Filterable
  include PublicActivity::Common

  belongs_to :user
  belongs_to :feeling, optional: true
  belongs_to :post_activity, optional: true, foreign_key: :activity_id
  belongs_to :location, optional: true
  belongs_to :parent, polymorphic: true, counter_cache: true, optional: true
  belongs_to :permission

  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tagged_users, through: :taggings, source: :tagger, source_type: 'User', dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :group_posts, dependent: :destroy
  has_many :groups, through: :group_posts
  has_many :post_reports

  accepts_nested_attributes_for :taggings, allow_destroy: true

  scope :daily_temp_post, -> { where('remove_datetime is not null and remove_datetime <= ? and status = ?', Time.now, 4)}

  after_commit :create_hashtags

  def create_hashtags
    taggings.destroy_all if taggings.present?
    body.scan(/#\w+/).flatten.each do |tag|
      taggings.create(context: tag.gsub("#", ""))
    end
  end
end
