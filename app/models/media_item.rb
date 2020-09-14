class MediaItem < ApplicationRecord

  has_one_attached :media_items

  validates :media_items, presence: true, blob: { content_type: :image }

  before_create :generate_media_token

  def generate_media_token
    self.media_token = SecureRandom.base58(24)
  end

end
