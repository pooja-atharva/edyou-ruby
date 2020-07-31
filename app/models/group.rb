class Group < ApplicationRecord
  include Status
  has_many :groups_users, dependent: :destroy
  has_many :users, through: :groups_users
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  validate :check_admin_user

  accepts_nested_attributes_for :groups_users, allow_destroy: true

  validates :name,  presence: true
  validates :owner, presence: true

  before_create :add_owner_in_group


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
    groups_users.build(user_id: owner_id, admin: true)
  end

  def check_admin_user
    if groups_users.reject{|gu| !gu.admin? || gu._destroy }.none?
      errors.add(:base, 'At least one admin user must be required')
    end
  end
end