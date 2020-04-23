class AddPlantIdToPlantTimeSheet < ActiveRecord::Migration[5.2]
  def change
    add_reference :plant_time_sheets, :plant, foreign_key: true
  end
end
