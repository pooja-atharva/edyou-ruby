class CreateChatroomUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :chatroom_users do |t|
      t.references :chatroom, foreign_key: true
      t.references :user, foreign_key: true
      t.datetime :last_read_at
      t.integer :message_id
      t.integer :status
      t.boolean :is_admin, default: false
      t.timestamps
    end
  end
end
