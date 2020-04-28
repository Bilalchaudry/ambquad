class CreateBudgetHolders < ActiveRecord::Migration[5.2]
  def change
    create_table :budget_holders do |t|
      t.integer :employee_id
      t.integer :client_company_id

      t.timestamps
    end
  end
end
