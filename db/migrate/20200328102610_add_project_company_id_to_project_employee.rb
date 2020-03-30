class AddProjectCompanyIdToProjectEmployee < ActiveRecord::Migration[5.2]
  def change
    add_column :project_employees, :project_company_id, :integer
  end
end
