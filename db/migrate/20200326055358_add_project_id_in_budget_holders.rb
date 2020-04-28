class AddProjectIdInBudgetHolders < ActiveRecord::Migration[5.2]
  def change
    add_column :budget_holders, :project_id, :integer
  end
end
