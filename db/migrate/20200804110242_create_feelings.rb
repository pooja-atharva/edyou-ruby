class CreateFeelings < ActiveRecord::Migration[6.0]
  def change
    create_table :feelings do |t|
      t.string :name
      t.string :emoji_symbol

      t.timestamps
    end
  end
end
