class AddCountryCodeToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :country_code, :string
  end
end
