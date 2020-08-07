class Activity < ApplicationRecord
  belongs_to :parent_activity, class_name: "Activity", foreign_key: "parent_id", optional: true
  has_many :sub_activities, class_name: "Activity", foreign_key: "parent_id"
  has_many :posts

  scope :main_activities, -> { where(parent_id: nil) }
end
