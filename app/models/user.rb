class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  has_one_time_password length: 6
  has_many :friendships, ->(user) {
    unscope(:where).where(user: user).or(where(friend: user))
  }

  has_many :groups_users
  has_and_belongs_to_many :groups
  has_many :own_groups, class_name: 'Group', foreign_key: :owner_id

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

  def email_changed?
    false
  end

  private

  def generate_token
    SecureRandom.hex(10)
  end
end
