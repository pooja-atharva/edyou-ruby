class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.text :body
      t.datetime :publish_date
      t.integer :parent_id
      t.string :parent_type
      t.integer :comment_count, default: 0
      t.integer :like_count, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
