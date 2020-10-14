class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.references :chatroom, foreign_key: true
      t.references :user, foreign_key: true
      t.text :body
      t.datetime :deleted_at
      t.string :media_type
      t.text :file_url
      t.timestamps
    end
  end
end
