class AddPostDeleteToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :delete_post_after_24_hour, :boolean, default: false
  end
end
