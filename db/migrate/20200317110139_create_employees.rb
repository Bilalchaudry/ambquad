class CreateEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :employees do |t|
      t.string :first_name
      t.string :last_name
      t.integer :employee_id
      t.integer :phone
      t.string :email
      t.integer :gender, default: 0
      t.text :home_company_role
      t.date :contract_start_date
      t.date :contract_end_date
      t.integer :status, default: 0
      t.integer :project_company_id
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
