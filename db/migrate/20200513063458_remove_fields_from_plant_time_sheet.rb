class RemoveFieldsFromPlantTimeSheet < ActiveRecord::Migration[5.2]
  def change
    remove_column :plant_time_sheets, :plant_id_str
    remove_column :plant_time_sheets, :manager
  end
end
