class AddCostCodeToEmployeeTimeSheet < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_time_sheets, :cost_code, :string
  end
end
