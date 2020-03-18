class TypeToMangerType < ActiveRecord::Migration[5.2]
  def change
    rename_column :other_managers, :type, :manager_type
  end
end
