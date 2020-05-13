class RemoveFieldsFromEmployeeTimeSheet < ActiveRecord::Migration[5.2]
  def change
    remove_column :employee_time_sheets, :employee
    remove_column :employee_time_sheets, :manager
    remove_column :employee_time_sheets, :cost_code
  end
end
