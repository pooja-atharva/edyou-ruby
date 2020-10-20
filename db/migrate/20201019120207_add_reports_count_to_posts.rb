class AddReportsCountToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :post_reports_count, :integer
  end
end
