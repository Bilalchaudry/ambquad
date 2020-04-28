class AddUserNameToEmployees < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :user_name, :string
  end
end
