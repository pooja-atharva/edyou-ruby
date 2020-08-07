class AddFeelingsToPosts < ActiveRecord::Migration[6.0]
  def change
    add_reference :posts, :feeling, null: true, foreign_key: true
  end
end
