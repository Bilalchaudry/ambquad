class AddBudgetHolderToCostCodes < ActiveRecord::Migration[5.2]
  def change
    add_column :cost_codes, :budget_holder_id, :integer
  end
end
