class ChatroomUser < ApplicationRecord
  belongs_to :chatroom, touch: true
  belongs_to :user

  enum status: %i[joined pending rejected cancelled left]

end
