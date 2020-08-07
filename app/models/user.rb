class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  acts_as_followable
  acts_as_follower

  has_one_time_password length: 6
  has_many :friendships, ->(user) {
    unscope(:where).where(user: user).or(where(friend: user))
  }
  has_many :approved_friendships, -> { where status: :approved }, class_name: 'Friendship', dependent: :destroy
  has_many :friends, through: :approved_friendships, class_name: 'User', dependent: :destroy
  has_one :profile

  has_many :groups_users
  has_and_belongs_to_many :groups
  has_many :own_groups, class_name: 'Group', foreign_key: :owner_id
  has_many :posts, dependent: :destroy

  has_many :taggings, as: :tagger, dependent: :destroy
  has_many :tagged_posts, through: :taggings, source: :taggable, source_type: 'Post', dependent: :destroy

  accepts_nested_attributes_for :taggings, allow_destroy: true

  validates :email, format: { with: /\b[A-Z0-9._%a-z\-]+@edu.com\z/, message: 'must be from edu account' }, if: :from_website?

  def from_website?
    google_id.nil?
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
end
