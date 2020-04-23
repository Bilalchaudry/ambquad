class AddPlantIntIdToPlantTimeSheet < ActiveRecord::Migration[5.2]
  def change
    add_column :plant_time_sheets, :plant_id_int, :integer
  end
end
