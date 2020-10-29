class CreateNotificationSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :notification_settings do |t|
      t.references :user, null: false, foreign_key: true
      t.string :notification_type
      t.boolean :notify, default: true

      t.timestamps
    end
  end
end
