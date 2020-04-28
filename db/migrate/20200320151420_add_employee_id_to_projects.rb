class AddEmployeeIdToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :employee_id, :integer
  end
end
