class AddTimeSheetEmployeeIdToTimeSheetCostCode < ActiveRecord::Migration[5.2]
  def change
    add_column :time_sheet_cost_codes, :time_sheet_employee_id, :integer
    add_column :time_sheet_cost_codes, :time_sheet_plant_id, :integer
  end
end
