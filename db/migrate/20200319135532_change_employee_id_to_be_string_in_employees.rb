class ChangeEmployeeIdToBeStringInEmployees < ActiveRecord::Migration[5.2]
  def change
    change_column :employees ,:employee_id, :string
  end
end
