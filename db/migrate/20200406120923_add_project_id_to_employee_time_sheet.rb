class AddProjectIdToEmployeeTimeSheet < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_time_sheets, :project_id, :integer
  end
end
