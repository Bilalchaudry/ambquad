class AddPlantIdToTimeSheetCostCode < ActiveRecord::Migration[5.2]
  def change
    add_reference :time_sheet_cost_codes, :plant, foreign_key: true
  end
end
