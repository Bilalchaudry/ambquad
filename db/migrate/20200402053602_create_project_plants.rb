class CreateProjectPlants < ActiveRecord::Migration[5.2]
  def change
    create_table :project_plants do |t|
      t.integer :plant_id
      t.integer :plant_type_id
      t.integer :project_company_id
      t.date :contract_start_date
      t.date :contract_end_date
      t.integer :foreman_id
      t.integer :other_manager_id
      t.integer :status
      t.integer :client_company_id

      t.timestamps
    end
  end
end
