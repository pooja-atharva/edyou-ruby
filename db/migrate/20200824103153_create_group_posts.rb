class CreateGroupPosts < ActiveRecord::Migration[6.0]
  def change
    create_table :group_posts do |t|
      t.references :group, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
