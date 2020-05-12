class AddPlantTimeSheetIdToTimeSheetCostCodes < ActiveRecord::Migration[5.2]
  def change
    add_column :time_sheet_cost_codes, :plant_time_sheet_id, :integer
  end
end
