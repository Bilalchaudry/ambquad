class AddClientCompanyIdToEmployee < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :client_company_id, :integer
  end
end
