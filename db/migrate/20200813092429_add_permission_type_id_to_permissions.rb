class AddPermissionTypeIdToPermissions < ActiveRecord::Migration[6.0]
  def change
    remove_column :permissions, :action_name, :string
    remove_column :permissions, :action_description, :string
    remove_column :permissions, :action, :string
    add_column :permissions, :permission_type_id, :integer
  end
end
 