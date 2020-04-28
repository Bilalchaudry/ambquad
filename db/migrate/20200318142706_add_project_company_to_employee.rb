class AddProjectCompanyToEmployee < ActiveRecord::Migration[5.2]
  def change
    remove_column :employees, :project_company_id
    add_reference :employees, :project_company, foreign_key: true
  end
end
