class AddCountryCodeToClientCompany < ActiveRecord::Migration[5.2]
  def change
    add_column :client_companies, :phone_country_code, :string
    add_column :client_companies, :primary_poc_country_code, :string
  end
end
