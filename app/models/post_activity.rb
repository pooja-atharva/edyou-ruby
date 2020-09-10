class PostActivity < ApplicationRecord
  belongs_to :parent_activity, class_name: "PostActivity", foreign_key: "parent_id", optional: true
  has_many :sub_activities, class_name: "PostActivity", foreign_key: "parent_id"
  has_many :posts, foreign_key: "activity_id"

  scope :main_activities, -> { where(parent_id: nil) }
end
