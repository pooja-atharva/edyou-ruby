class CreateGroupsUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :groups_users do |t|
      t.integer :group_id
      t.integer :user_id
      t.boolean :admin, default: false
      t.timestamps
    end
    add_index :groups_users, :group_id
    add_index :groups_users, :user_id
    add_index :groups_users, :admin
  end
end
