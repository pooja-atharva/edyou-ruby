class Location < ApplicationRecord
  has_many :posts

  scope :search_with_name, -> (query) { where("name ilike ?", "%#{query}%") }
end
