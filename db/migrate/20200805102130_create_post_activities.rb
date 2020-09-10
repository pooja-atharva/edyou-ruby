class CreatePostActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :activities do |t|
      t.string :name
      t.string :emoji_symbol
      t.integer :parent_id

      t.timestamps
    end
  end
end
