class AddProjectIdToProjectPlants < ActiveRecord::Migration[5.2]
  def change
    add_column :project_plants, :project_id, :integer
  end
end
