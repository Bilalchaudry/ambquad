class AddCountryToTemporaryUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :temporary_users, :country_name, :string
    add_column :users, :country_name, :string
    add_column :client_companies, :country_name, :string
  end
end
