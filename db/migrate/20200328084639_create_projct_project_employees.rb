class CreateProjctProjectEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :project_project_employees do |t|
      t.integer :project_id
      t.integer :project_employee_id

      t.timestamps
    end
  end
end
