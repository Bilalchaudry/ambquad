class RenameEmployeCreatedAtColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :employee_time_sheets, :employee_create_date, :timesheet_created_at
  end
end
