class CreateMediaItems < ActiveRecord::Migration[6.0]
  def change
    create_table :media_items do |t|
      t.string :media_token
      t.timestamps
    end
    add_index :media_items, :media_token
  end
end
