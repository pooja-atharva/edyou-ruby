class CreateDevices < ActiveRecord::Migration[6.0]
  def change
    create_table :devices do |t|
      t.integer :device_type
      t.string :token
    	t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
