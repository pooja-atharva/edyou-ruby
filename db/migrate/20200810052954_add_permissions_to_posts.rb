class AddPermissionsToPosts < ActiveRecord::Migration[6.0]
  def change
    add_reference :posts, :permission, null: true, foreign_key: true
    add_column :posts, :access_requirement_ids, :integer, array: true, default: []
  end
end
