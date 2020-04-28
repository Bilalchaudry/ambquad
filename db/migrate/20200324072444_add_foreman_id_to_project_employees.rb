class AddForemanIdToProjectEmployees < ActiveRecord::Migration[5.2]
  def change
    add_column :project_employees, :foreman_id, :integer
    add_column :project_employees, :other_manager_id, :integer
  end
end
