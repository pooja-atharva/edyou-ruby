class AddCreatedByToChatroom < ActiveRecord::Migration[6.0]
  def change
    add_reference :chatrooms, :created_by, foreign_key: { to_table: :users }
  end
end
