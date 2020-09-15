class AddStatusToGroupsUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :groups_users, :status, :integer, default: 0
  end
end
