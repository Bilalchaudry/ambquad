class AddClientCompanyIdToEmployeeTypes < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_types, :client_company_id, :integer
  end
end
