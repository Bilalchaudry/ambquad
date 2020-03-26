class AddProjectIdToEmployeeType < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_types, :project_id, :integer
    add_column :foremen, :project_id, :integer
    add_column :other_managers, :project_id, :integer
    add_column :plant_types, :project_id, :integer
    add_column :plants, :project_id, :integer
  end
end
