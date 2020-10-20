class CreatePostReports < ActiveRecord::Migration[6.0]
  def change
    create_table :post_reports do |t|
      t.string :reason
      t.references :post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
