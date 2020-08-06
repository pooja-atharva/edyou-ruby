class CreateProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :class_name
      t.string :graduation
      t.string :major
      t.string :status
      t.string :attending_university
      t.string :high_school
      t.string :from_location
      t.string :gender
      t.string :religion
      t.string :language
      t.date :date_of_birth
      t.string :favourite_quotes
      t.timestamps
    end
  end
end
