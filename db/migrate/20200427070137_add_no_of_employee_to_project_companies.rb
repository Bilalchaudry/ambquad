class AddNoOfEmployeeToProjectCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :project_companies, :number_of_employee, :integer, default: 0
  end
end
