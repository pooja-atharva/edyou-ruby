class UserProfile < ApplicationRecord
  belongs_to :user
  
  enum marital_status: %w[Married Single]
  enum gender: %w[Male Female Other]
  enum graduation: %w[postgraducation graducation highschool]
end