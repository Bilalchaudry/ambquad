class AddProjectIdToPlantTimeSheet < ActiveRecord::Migration[5.2]
  def change
    add_reference :plant_time_sheets, :project, foreign_key: true
  end
end
