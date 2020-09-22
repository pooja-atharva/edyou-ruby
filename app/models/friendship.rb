class Friendship < ApplicationRecord
  include Filterable
  include Status
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: :friend_id

  before_create :set_invite_date
  validates :user, presence: true
  validates :friend, presence: true, uniqueness: {scope: [:user_id], message: 'request is already sent'}

  scope :with_user, -> (user_id) {where(user_id: user_id).or(where(friend_id: user_id))}

  def set_invite_date
    self.invite_sent = Time.now
  end

  def set_approved!
    update_column(:status, :approved)
  end

  def set_declined!
    update_column(:status, :declined)
  end

  def set_cancelled!
    update_column(:status, :cancelled)
  end

  def set_pending
    status = :pending
  end

  def unfriend?
    declined? || cancelled?
  end
end
