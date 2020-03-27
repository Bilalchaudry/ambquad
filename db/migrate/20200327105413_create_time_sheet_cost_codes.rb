class CreateTimeSheetCostCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :time_sheet_cost_codes do |t|
      t.string :cost_code
      t.integer :cost_code_id
      t.float :hrs

      t.timestamps
    end
  end
end
