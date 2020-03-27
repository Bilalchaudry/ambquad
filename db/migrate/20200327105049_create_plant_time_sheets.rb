class CreatePlantTimeSheets < ActiveRecord::Migration[5.2]
  def change
    create_table :plant_time_sheets do |t|
      t.string :plant_id
      t.string :plant_name
      t.integer :plant_id
      t.string :company
      t.integer :project_company_id
      t.string :manager
      t.integer :foreman_id
      t.float :total_hours

      t.timestamps
    end
  end
end
