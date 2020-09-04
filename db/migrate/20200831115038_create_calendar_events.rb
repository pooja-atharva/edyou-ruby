class CreateCalendarEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :calendar_events do |t|
      t.integer :user_id
      t.string :title
      t.text :description
      t.string :location
      t.datetime :datetime_at
      t.string :price
      t.string :event_type
      t.integer :status, default: 4
      t.timestamps
    end
    add_index :calendar_events, :user_id
    add_index :calendar_events, :title
    add_index :calendar_events, :datetime_at
    add_index :calendar_events, :status
  end
end
