class CreateFriendships < ActiveRecord::Migration[6.0]
  def change
    create_table :friendships do |t|
      t.integer :user_id
      t.integer :friend_id
      t.integer :status, default: 0
      t.datetime :invite_sent
      t.timestamps
    end
    add_index :friendships, :user_id
    add_index :friendships, :friend_id
    add_index :friendships, :status
  end
end
