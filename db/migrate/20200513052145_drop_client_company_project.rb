class DropClientCompanyProject < ActiveRecord::Migration[5.2]
  def change
    drop_table :client_company_projects
    drop_table :project_employees
    drop_table :project_plants
    # drop_join_table :projects, :project_employees
    # drop_join_table :projects, :project_companies
  end
end
