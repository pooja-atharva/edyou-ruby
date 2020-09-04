class GroupsUser < ApplicationRecord
  belongs_to :group, counter_cache: :users_count
  belongs_to :user

  # validates :group_id#, presence: true
  validates :user_id, presence: true, uniqueness: { scope: :group_id }

  scope :admin, -> { where(admin: true) }
  scope :non_admin, -> { where(admin: false ) }
end
