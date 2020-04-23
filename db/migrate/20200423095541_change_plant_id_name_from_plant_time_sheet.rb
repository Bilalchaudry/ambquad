class ChangePlantIdNameFromPlantTimeSheet < ActiveRecord::Migration[5.2]
  def change
    rename_column :plant_time_sheets, :plant_id, :plant_id_str
  end
end
