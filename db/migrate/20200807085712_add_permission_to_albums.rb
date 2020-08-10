class AddPermissionToAlbums < ActiveRecord::Migration[6.0]
  def change
    add_reference :albums, :permission, null: true, foreign_key: true
    add_column :albums, :access_requirement_ids, :integer, array: true, default: []
  end
end
