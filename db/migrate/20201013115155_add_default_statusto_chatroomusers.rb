class AddDefaultStatustoChatroomusers < ActiveRecord::Migration[6.0]
  def change
    change_column :chatroom_users, :status, :integer, default: 0
  end
end
