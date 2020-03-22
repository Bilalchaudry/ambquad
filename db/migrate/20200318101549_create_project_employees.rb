class CreateProjectEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :project_employees do |t|
      t.time :total_hours
      t.date :contract_start_date
      t.date :contract_end_date
      t.references :employee, foreign_key: true
      t.references :employee_type, foreign_key: true
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
