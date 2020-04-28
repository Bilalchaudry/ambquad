class AddPocNameToClientCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :client_companies, :poc_name, :string
  end
end
