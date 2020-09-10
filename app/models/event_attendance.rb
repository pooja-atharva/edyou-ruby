class EventAttendance < ApplicationRecord
  belongs_to :user
  belongs_to :calendar_event
end
