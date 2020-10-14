class Chatroom < ApplicationRecord
  include Discard::Model

  has_many :chatroom_users, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :users, through: :chatroom_users
  belongs_to :created_by, class_name: "User", optional: true
  has_one_attached :group_image, dependent: :destroy

  validates :name, presence: true

  scope :public_channels, -> { where(direct_message: false) }
  scope :direct_messages, -> { where(direct_message: true) }
  ChatroomUser.statuses.each do |status, value|
    has_many "#{status}_users".to_sym, -> { merge(ChatroomUser.send(status)) },
             through: :chatroom_users, source: :user
    has_many "#{status}_chatroom_users".to_sym, -> { merge(ChatroomUser.send(status)) },
              class_name: 'ChatroomUser'
  end
  scope :joined_users, (lambda do
    includes(:chatroom_users).where(chatroom_users: { status: :joined })
  end)

  def self.direct_message_for_users(users)
    user_ids = users.map(&:id).sort
    name = "DM:#{user_ids.join(":")}"
    if chatroom = direct_messages.where(name: name).first
      chatroom
    else
      # create a new chatroom
      chatroom = new(name: name, direct_message: true)
      chatroom.users = users
      chatroom.save
      chatroom
    end
  end

  def self.html(chatroom, current_user)
    ApplicationController.render(
      partial: 'api/v1/chatrooms/chatroom',
      locals: { chatroom: chatroom, current_user: current_user }
    )
  end

  def self.participants_detail(chatroom, user_id)
    participants = User.where(id: user_id)
    ApplicationController.render(
      partial: 'api/v1/chatroom_users/participants_detail',
      locals: { chatroom: chatroom, users: participants }
    )
  end

  def user_ids
    joined_users.collect(&:id)
  end

  def last_msg
    messages&.kept&.last
  end

  def other_user(current_user)
    users.where.not(id: current_user.id).last
  end

end
