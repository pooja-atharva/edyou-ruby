class AddDiscardedToMessages < ActiveRecord::Migration[6.0]
  def change
    rename_column :messages, :deleted_at, :discarded_at
    add_index :messages, :discarded_at
  end
end
