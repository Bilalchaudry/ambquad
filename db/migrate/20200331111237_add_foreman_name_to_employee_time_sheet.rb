class AddForemanNameToEmployeeTimeSheet < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_time_sheets, :foreman_name, :string
  end
end
