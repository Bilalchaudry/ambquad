class AddContractStartDateToEmployees < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :project_role, :string
  end
end
