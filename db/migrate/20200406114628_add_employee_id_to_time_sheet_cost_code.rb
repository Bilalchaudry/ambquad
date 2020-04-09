class AddEmployeeIdToTimeSheetCostCode < ActiveRecord::Migration[5.2]
  def change
    add_column :time_sheet_cost_codes, :employee_id, :integer
  end
end
