class AddOtherManagerIdToPlants < ActiveRecord::Migration[5.2]
  def change
    add_column :plants, :other_manager_id, :integer
  end
end
