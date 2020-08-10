class AddContributorsToAlbums < ActiveRecord::Migration[6.0]
  def change
    add_column :albums, :allow_contributors, :boolean, default: false
  end
end
