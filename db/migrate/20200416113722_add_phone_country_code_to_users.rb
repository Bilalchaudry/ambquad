class AddPhoneCountryCodeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :phone_country_code, :string
    add_column :temporary_users, :phone_country_code, :string
  end
end
