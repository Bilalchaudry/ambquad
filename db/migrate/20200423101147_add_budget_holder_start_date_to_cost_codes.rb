class AddBudgetHolderStartDateToCostCodes < ActiveRecord::Migration[5.2]
  def change
    add_column :cost_codes, :budget_holder_start_date, :date
  end
end
