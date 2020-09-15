class CreateHashtags < ActiveRecord::Migration[6.0]
  def change
    create_table :hashtags do |t|
      t.string :context
      t.integer :count, default: 0

      t.timestamps
    end
  end
end
