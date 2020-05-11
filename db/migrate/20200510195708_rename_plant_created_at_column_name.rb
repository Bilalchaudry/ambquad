class RenamePlantCreatedAtColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :plant_time_sheets, :plant_create_date, :timesheet_created_at
  end
end
