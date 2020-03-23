class AddOffloadToPlants < ActiveRecord::Migration[5.2]
  def change
    add_column :plants, :offload, :boolean, default: false
  end
end
