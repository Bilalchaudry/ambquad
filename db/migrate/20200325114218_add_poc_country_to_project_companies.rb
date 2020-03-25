class AddPocCountryToProjectCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :project_companies, :poc_country, :string
  end
end
