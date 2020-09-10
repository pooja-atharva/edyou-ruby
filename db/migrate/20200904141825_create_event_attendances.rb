class CreateEventAttendances < ActiveRecord::Migration[6.0]
  def change
    create_table :event_attendances do |t|
      t.bigint :user_id
      t.bigint :calendar_event_id
      t.string :status

      t.timestamps
    end
  end
end
