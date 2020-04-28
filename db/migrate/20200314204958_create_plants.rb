class CreatePlants < ActiveRecord::Migration[5.2]
  def change
    create_table :plants do |t|
      t.string :plant_name
      t.string :plant_id
      t.integer :plant_type_id
      t.integer :project_company_id
      t.date :contract_start_date
      t.date :contract_end_date
      t.string :market_value
      t.integer :status

      t.timestamps
    end
  end
end
