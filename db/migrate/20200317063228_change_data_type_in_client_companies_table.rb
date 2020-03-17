class ChangeDataTypeInClientCompaniesTable < ActiveRecord::Migration[5.2]
  def change

    change_column :client_companies, :primary_poc_first_name, :string
    change_column :client_companies, :primary_poc_last_name, :string
    change_column :client_companies, :poc_email, :string
    change_column :client_companies, :poc_phone, :string

  end
end
