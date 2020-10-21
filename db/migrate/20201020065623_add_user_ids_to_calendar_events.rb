class AddUserIdsToCalendarEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :calendar_events, :user_ids, :integer, array: true, default: []
    add_column :calendar_events, :group_ids, :integer, array: true, default: []
  end
end
