class AddCityStateToClientCompany < ActiveRecord::Migration[5.2]
  def change
    add_column :client_companies, :city, :string
    add_column :client_companies, :state, :string
  end
end
