class AddColumnForSubmitTimeSheet < ActiveRecord::Migration[5.2]
  def change
    add_column :employee_time_sheets, :submit_sheet, :boolean, default: false
    add_column :plant_time_sheets, :submit_sheet, :boolean, default: false
  end
end
