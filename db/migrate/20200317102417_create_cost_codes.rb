class CreateCostCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :cost_codes do |t|
      t.string :cost_code_id
      t.string :cost_code_description
      t.integer :project_id

      t.timestamps
    end
  end
end
