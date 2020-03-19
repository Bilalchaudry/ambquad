class ChangeTotalHoursToBeFloatInProjectEmployees < ActiveRecord::Migration[5.2]
  def change
    remove_column :project_employees, :total_hours

    add_column :project_employees, :total_hours, :float
  end
end
