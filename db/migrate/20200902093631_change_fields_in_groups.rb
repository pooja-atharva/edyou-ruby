class ChangeFieldsInGroups < ActiveRecord::Migration[6.0]
  def change
    rename_column :groups, :string, :description
  end
end
