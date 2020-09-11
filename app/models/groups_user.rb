class GroupsUser < ApplicationRecord
  include Status
  belongs_to :group
  belongs_to :user

  # validates :group_id#, presence: true
  validates :user_id, presence: true, uniqueness: { scope: :group_id }

  scope :admin, -> { where(admin: true) }
  scope :non_admin, -> { where(admin: false ) }

  def set_approved!
    update_column(:status, :approved)
  end

  def set_declined!
    update_column(:status, :declined)
  end
end
