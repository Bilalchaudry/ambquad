class AddForemanNameToPlantTimeSheet < ActiveRecord::Migration[5.2]
  def change
    add_column :plant_time_sheets, :foreman_name, :string
  end
end
