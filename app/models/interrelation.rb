class Interrelation < ApplicationRecord
  belongs_to :user
  belongs_to :close_friend, class_name: 'User', foreign_key: :friend_id

  validates :user, presence: true
  validates :close_friend, presence: true
end
