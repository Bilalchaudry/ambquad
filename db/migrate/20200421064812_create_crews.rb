class CreateCrews < ActiveRecord::Migration[5.2]
  def change
    create_table :crews do |t|
      t.integer :employee_id
      t.integer :plant_id
      t.integer :foreman_id
      t.integer :project_id

      t.timestamps
    end
  end
end
