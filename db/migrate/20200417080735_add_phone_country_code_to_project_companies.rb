class AddPhoneCountryCodeToProjectCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :project_companies, :phone_country_code, :string
    add_column :project_companies, :poc_phone_country_code, :string
  end
end
