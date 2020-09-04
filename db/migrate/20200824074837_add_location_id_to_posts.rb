class AddLocationIdToPosts < ActiveRecord::Migration[6.0]
  def change
    add_reference :posts, :location, null: true, foreign_key: true
  end
end
