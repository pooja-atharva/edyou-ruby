class AddCountryToProfile < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :country, :string
  end
end
