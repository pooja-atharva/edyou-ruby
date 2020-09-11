class Group < ApplicationRecord
  include Filterable
  include Status
  include ActiveStorageSupport::SupportForBase64
  has_many :groups_users, dependent: :destroy
  has_many :users, through: :groups_users
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  validate :check_admin_user

  has_many :group_posts, dependent: :destroy
  has_many :posts, through: :group_posts
  # has_one_base64_attached :avatar

  accepts_nested_attributes_for :groups_users, allow_destroy: true

  validates :name,  presence: true
  validates :owner, presence: true
  validates :email, format: { with: Devise.email_regexp, message: 'format is invalid' }, allow_blank: true

  after_create :add_owner_in_group
  after_commit :update_users_count

  def update_users_count
    self.users_count = GroupsUser.where(status: 'approved', group_id: id).count
    self.save!
  end

  def initialize(attributes={})
    super
    self.status ||= STATUSES[:active]
  end

  def leave_group(user)
    if groups_users.admin.where.not(user_id: user.id).any?
      groups_users.where(user_id: user.id).destroy_all
    else
      errors.add(:base, 'Please set at least one admin user before you leave this group.')
      false
    end
  end

  private

  def add_owner_in_group
    if groups_users.where(user_id: owner_id).none?
      groups_users.create(user_id: owner_id, admin: true)
    end
  end

  def check_admin_user
    if !new_record? && groups_users.reject{|gu| !gu.admin? || gu._destroy }.none?
      errors.add(:base, 'At least one admin user must be required')
    end
  end
end
