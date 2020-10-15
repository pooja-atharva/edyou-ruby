class User < ApplicationRecord
  include Filterable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  acts_as_followable
  acts_as_follower

  has_one_time_password length: 6
  has_many :friendships, ->(user) {
    unscope(:where).where(user: user).or(where(friend: user))

  }, dependent: :destroy
  has_many :approved_friendships, -> (user) {
    unscope(:where).where(user: user).or(where(friend: user)).where(status: :approved)
  }, class_name: 'Friendship', dependent: :destroy
  # has_many :friends, through: :approved_friendships, class_name: 'User', dependent: :destroy

  has_many :close_friendships, -> { where relavance: 'close_friends' }, class_name: 'Interrelation', dependent: :destroy, foreign_key: 'user_id'
  has_many :close_friends, through: :close_friendships, class_name: 'User', foreign_key: 'friend_id', dependent: :destroy

  has_one :profile

  has_many :groups_users
  has_and_belongs_to_many :groups
  has_many :own_groups, class_name: 'Group', foreign_key: :owner_id
  has_many :posts, dependent: :destroy
  has_many :calendar_events, dependent: :destroy

  has_many :chatroom_users
  has_many :chatrooms, through: :chatroom_users
  has_many :messages, dependent: :destroy

  has_many :taggings, as: :tagger, dependent: :destroy
  has_many :tagged_posts, through: :taggings, source: :taggable, source_type: 'Post', dependent: :destroy

  has_one_attached :profile_image
  has_many_attached :cover_images
  has_many :albums, dependent: :destroy
  has_many :contributors, dependent: :destroy
  has_many :contributing_albums, through: :contributors, source: :album
  has_many :privacy_settings
  has_many :event_attendances
  has_many :support_tickets

  accepts_nested_attributes_for :taggings, allow_destroy: true
  accepts_nested_attributes_for :contributors, allow_destroy: true

  validates :email, format: { with: /\b[A-Z0-9._%a-z\-]+@edu.com\z/, message: 'must be from edu account' }, if: :from_website?

  scope :search_with_name, -> (query) { where("name ilike ?", "%#{query}%") }
  scope :exclude_blocks, -> (user){ where.not(id: user.try(:blocks) || [])}
  scope :blocked_users, -> { where(blocked: true) }

  after_create :set_privacy_settings
  after_save :revoke_all_access_tokens!

  def exclude_block_user(user)
    self.blocks.include?(user) || user.blocks.include?(self)
  end

  def self.search(query)
    where("name ilike ? OR email = ?", "%#{query}%","#{query}")
  end

  def friends
    User.where(id: approved_friendships.pluck(:user_id, :friend_id).flatten).where.not(id: self.id)
  end

  def set_privacy_settings
    default_permission_type_id = PermissionType.find_by(action: 'public').id
    Constant::PRIVACY_SETTING_OBJECTS.each do |ps_object|
      privacy_settings.find_or_create_by(permission_type_id: default_permission_type_id, action_object: ps_object)
    end
  end

  def default_permission(action_object)
    default_permission_type = privacy_settings.find_by(action_object: action_object).permission_type
    permission = Permission.find_by(action_object: action_object, permission_type_id: default_permission_type.id)
    return permission
  end

  def from_website?
    google_id.nil?
  end

  def profile_pic_url
    profile_image.service_url.sub(/\?.*/, '') if profile_image.attached?
  end

  def generate_password_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now.utc
    save!
  end

  def password_token_valid?
    (reset_password_sent_at + 4.hours) > Time.now.utc
  end

  def reset_password!(password)
    self.reset_password_token = nil
    self.password = password
    save!
  end

  def send_otp_for_forgot
    UserMailer.send_otp_for_forgot(self).deliver_now
  end

  def email_changed?
    false
  end

  private

  def generate_token
    SecureRandom.hex(10)
  end

  def revoke_all_access_tokens!
    Doorkeeper::AccessToken.revoke_all_for(Doorkeeper::Application.pluck(:id), self) if blocked?
  end
end
