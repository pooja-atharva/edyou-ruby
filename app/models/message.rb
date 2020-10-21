class Message < ApplicationRecord
  include Discard::Model

  belongs_to :chatroom
  belongs_to :user

  has_one_attached :file, dependent: :destroy

  def self.sizes
    {
      thumbnail: { resize: "414x200" },
      hero1:     { resize: "1000x500" }
    }
  end

  def sized(size)
    variant = self.file.variant(Message.sizes[size]).processed
    variant.service_url(expires_in: Rails.application.config.active_storage.service_urls_expire_in)
  end

  def video_thumb(size)
    variant = self.file.preview(Message.sizes[size]).processed
    variant.service_url(expires_in: Rails.application.config.active_storage.service_urls_expire_in)
  end
end
