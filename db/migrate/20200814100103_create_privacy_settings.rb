class CreatePrivacySettings < ActiveRecord::Migration[6.0]
  def change
    create_table :privacy_settings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :permission_type, null: false, foreign_key: true
      t.string :action_object

      t.timestamps
    end
  end
end
