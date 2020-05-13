class DropJoinTables < ActiveRecord::Migration[5.2]
  def change
    drop_table :project_and_project_companies
    drop_table :project_project_employees
  end
end
