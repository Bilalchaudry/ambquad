class AddDateToEmployeeTimeSheet < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_time_sheets, :employee_create_date, :date
  end
end
