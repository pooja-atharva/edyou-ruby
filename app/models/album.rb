class Album < ApplicationRecord
  belongs_to :user
  belongs_to :permission
  has_many :posts
  has_many :contributors
  has_many :contributing_users, through: :contributors, source: :user

  accepts_nested_attributes_for :contributors, allow_destroy: true

  validates :name, presence: true
end
