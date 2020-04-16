class AddCountryToClientCompany < ActiveRecord::Migration[5.2]
  def change
    add_column :client_companies, :country, :string
  end
end
