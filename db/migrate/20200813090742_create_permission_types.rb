class CreatePermissionTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :permission_types do |t|
      t.string :action_name
      t.string :action_description
      t.string :action

      t.timestamps
    end
    add_index :permission_types, :action_name
    add_index :permission_types, :action
  end
end
