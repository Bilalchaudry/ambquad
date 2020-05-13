class RemoveFieldsFromProject < ActiveRecord::Migration[5.2]
  def change
    remove_column :projects, :employee_id
  end
end
