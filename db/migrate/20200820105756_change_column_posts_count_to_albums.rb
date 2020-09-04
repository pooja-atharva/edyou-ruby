class ChangeColumnPostsCountToAlbums < ActiveRecord::Migration[6.0]
  def change
    change_column :albums, :posts_count, :integer, default: 0
  end
end
