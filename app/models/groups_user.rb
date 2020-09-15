class GroupsUser < ApplicationRecord
  include Status
  belongs_to :group
  belongs_to :user

  # validates :group_id#, presence: true
  validates :user_id, presence: true, uniqueness: { scope: :group_id }

  scope :admin, -> { where(admin: true) }
  scope :non_admin, -> { where(admin: false ) }

  after_save :update_groups_count
  after_destroy :update_groups_count

  def set_approved!
    self.status = :approved
    save
  end

  def set_declined!
    self.destroy
  end

  def update_groups_count
    group.update_column(:users_count, group.groups_users.approved.count)
  end
end
