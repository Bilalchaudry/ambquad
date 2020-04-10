class AddEmployeeTimeSheetIdTooCostCodeTimeSheet < ActiveRecord::Migration[5.2]
  def change
    add_reference :time_sheet_cost_codes, :employee_time_sheet, foreign_key: true
  end
end
