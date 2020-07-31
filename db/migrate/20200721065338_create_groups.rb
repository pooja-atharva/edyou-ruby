class CreateGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.text :string
      t.integer :owner_id
      t.boolean :privacy, default: false
      t.string :university
      t.string :section
      t.string :president
      t.string :vice_president
      t.string :treasure
      t.string :social_director
      t.string :secretary
      t.string :email
      t.string :calendar_link
      t.integer :users_count
      t.integer :status
      t.timestamps
    end
    add_index :groups, :name
    add_index :groups, :owner_id
    add_index :groups, :status
    add_index :groups, :users_count
  end
end
