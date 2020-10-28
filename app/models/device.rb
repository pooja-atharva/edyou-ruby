class Device < ApplicationRecord
  belongs_to :user
  validates_presence_of :token
  enum device_type: [:ios, :android]
end
