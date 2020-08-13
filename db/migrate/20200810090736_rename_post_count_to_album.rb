class RenamePostCountToAlbum < ActiveRecord::Migration[6.0]
  def change
    rename_column :albums, :post_count, :posts_count
  end
end
