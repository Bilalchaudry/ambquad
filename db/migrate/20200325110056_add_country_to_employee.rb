class AddCountryToEmployee < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :country_name, :string
    add_column :project_companies, :country_name, :string
  end
end
