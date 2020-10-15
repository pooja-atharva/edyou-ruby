class CreateInterrelations < ActiveRecord::Migration[6.0]
  def change
    create_table :interrelations do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :friend_id, null: false, foreign_key: true
      t.string :relavance

      t.timestamps
    end
  end
end
