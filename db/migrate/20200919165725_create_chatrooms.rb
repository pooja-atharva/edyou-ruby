class CreateChatrooms < ActiveRecord::Migration[6.0]
  def change
    create_table :chatrooms do |t|
      t.string :name
      t.boolean :direct_message, default: false
      t.text :description
      t.text :last_message
      t.datetime :discarded_at
      t.timestamps
    end
  end
end
