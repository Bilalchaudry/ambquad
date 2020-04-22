class ChangeEmployeeDefaultRole < ActiveRecord::Migration[5.2]
  def change
    change_column :employees, :gender, :integer, :default => nil
    change_column :employees, :status, :integer, :default => nil
  end
end
