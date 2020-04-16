class FixColumnNameInEmployee < ActiveRecord::Migration[5.2]
  def change
    rename_column :employees, :user_name, :employee_name

  end
end
