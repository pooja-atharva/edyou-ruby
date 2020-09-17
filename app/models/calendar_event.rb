class CalendarEvent < ApplicationRecord
  include Status
  include Filterable
  belongs_to :user

  attr_accessor :media_tokens

  # has_many_base64_attached :images
  has_many_attached :media_items
  has_many :event_attendances

  attr_accessor :epoc_datetime_at
  validates :user_id, presence: true
  validates :title, presence: true
  validates :datetime_at, presence: true
  validates :price, presence: true
  validates :event_type, presence: true

  before_validation :set_datetime_at
  validate :validate_datetime, on: :create
  after_save :link_with_media_items
  after_create :create_event_request

  scope :passed_event, -> { where("datetime_at <= ? ",  DateTime.now) }
  # scope :active, -> { where(status: 'active') }

  def create_event_request
    User.find_each(batch_size: 200) do |user|
      user.event_attendances.find_or_create_by(calendar_event_id: id)
    end
  end

  def set_datetime_at
    if epoc_datetime_at
      self.datetime_at = DateTime.strptime(epoc_datetime_at.to_s,'%s')
    end
  end

  def validate_datetime
    if datetime_at <= Time.now
      errors.add(:base, 'Event datetime must be future time.')
    end
  end

  private

  def link_with_media_items
    return if media_tokens.blank? || media_tokens.empty?
    media_item_objects = MediaItem.where(media_token: media_tokens)
    ActiveStorage::Attachment.where(record: media_item_objects).update_all(record_id: self.id, record_type: self.class.name)
    media_item_objects.update_all(media_token: nil)
  end
end
