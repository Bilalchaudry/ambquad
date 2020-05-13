class RemoveFieldsFromEmployee < ActiveRecord::Migration[5.2]
  def change
    remove_column :employees, :first_name
    remove_column :employees, :last_name
  end
end
