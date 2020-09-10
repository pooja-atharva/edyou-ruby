class ChangeActivityToPostActivity < ActiveRecord::Migration[6.0]
  def change
    if ActiveRecord::Base.connection.table_exists? 'activities'
      rename_table :activities, :post_activities
    end
  end
end
