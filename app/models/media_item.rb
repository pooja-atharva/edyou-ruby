class MediaItem < ApplicationRecord

  has_one_attached :media_items

  before_create :generate_media_token

  def generate_media_token
    self.media_token = SecureRandom.base58(24)
  end

end
