class RemoveFieldsFromClientCompany< ActiveRecord::Migration[5.2]
  def change
    remove_column :client_companies, :email
    remove_column :client_companies, :primary_poc_first_name
    remove_column :client_companies, :primary_poc_last_name
    remove_column :client_companies, :closed_at
  end
end
