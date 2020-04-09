class AddColumnToPlantTimeSheet < ActiveRecord::Migration[5.2]
  def change
    add_column :plant_time_sheets, :plant_create_date, :date
  end
end
