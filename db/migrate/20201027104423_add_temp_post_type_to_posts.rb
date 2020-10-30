class AddTempPostTypeToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :temp_post_type, :string
    add_column :posts, :remove_datetime, :datetime
  end
end
