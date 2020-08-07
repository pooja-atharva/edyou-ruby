class CreatePermissions < ActiveRecord::Migration[6.0]
  def change
    create_table :permissions do |t|
      t.string :action_name
      t.string :action_description
      t.string :action_emoji
      t.string :action
      t.string :action_object

      t.timestamps
    end
  end
end
