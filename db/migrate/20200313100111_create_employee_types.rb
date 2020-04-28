class CreateEmployeeTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_types do |t|
      t.string :employee_type

      t.timestamps
    end
  end
end
