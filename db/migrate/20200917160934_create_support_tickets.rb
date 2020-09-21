class CreateSupportTickets < ActiveRecord::Migration[6.0]
  def change
    create_table :support_tickets do |t|
      t.references :user, null: false, foreign_key: true
      t.string :reason
      t.string :name
      t.string :email
      t.string :phone
      t.string :message
      t.timestamps
    end
  end
end
