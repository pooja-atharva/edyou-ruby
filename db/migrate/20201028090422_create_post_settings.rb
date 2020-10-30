class CreatePostSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :post_settings do |t|
      t.references :user, null: false, foreign_key: true
      t.string :remove_datetime

      t.timestamps
    end
  end
end
