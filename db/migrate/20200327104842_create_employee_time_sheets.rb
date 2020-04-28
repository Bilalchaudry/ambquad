class CreateEmployeeTimeSheets < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_time_sheets do |t|
      t.string :employee
      t.integer :employee_id
      t.string :labour_type
      t.integer :employee_type_id
      t.string :company
      t.integer :project_company_id
      t.string :manager
      t.integer :foreman_id
      t.float :total_hours

      t.timestamps
    end
  end
end
