class AddCountryCodeToEmployee < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :country_code, :string
  end
end
