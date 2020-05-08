class AddCostCodeCreatedAtToCostCodeTimeSheet < ActiveRecord::Migration[5.2]
  def change
    add_column :time_sheet_cost_codes, :cost_code_created_at, :date
  end
end
