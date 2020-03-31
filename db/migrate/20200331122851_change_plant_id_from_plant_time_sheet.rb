class ChangePlantIdFromPlantTimeSheet < ActiveRecord::Migration[5.2]
  def change
    change_column :plant_time_sheets, :plant_id, :string
  end
end
