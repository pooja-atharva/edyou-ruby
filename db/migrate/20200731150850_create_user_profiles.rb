class CreateUserProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :user_profiles do |t|
      t.string  :batch
      t.integer  :graduation
      t.string  :major
      t.integer  :marital_status
      t.string  :attending
      t.string  :high_school
      t.string  :address
      t.integer  :gender
      t.string  :religion
      t.string  :language
      t.date  :birthdate
      t.bigint :user_id

      t.timestamps
    end
  end
end
