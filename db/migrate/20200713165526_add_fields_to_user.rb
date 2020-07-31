class AddFieldsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :name, :string
    add_column :users, :otp_secret_key, :string
    add_column :users, :google_id, :string
  end
end
