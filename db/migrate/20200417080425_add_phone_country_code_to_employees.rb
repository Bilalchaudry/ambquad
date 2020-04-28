class AddPhoneCountryCodeToEmployees < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :phone_country_code, :string
  end
end
