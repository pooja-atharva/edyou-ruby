class Interrelation < ApplicationRecord
  belongs_to :user
  belongs_to :close_friend, class_name: 'User', foreign_key: :friend_id, optional: true
  belongs_to :roommate, class_name: 'User', foreign_key: :friend_id, optional: true

  validates :user, presence: true
  validates :friend_id, presence: true, uniqueness: { scope: [:user_id, :relavance]}
  # validates :close_friend, presence: true
  validate :validate_relavance

  def validate_relavance
    errors.add(:base, 'You can not add yourself in this relation') if user_id == friend_id
  end
end
