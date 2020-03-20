class AddForemanIdToPlants < ActiveRecord::Migration[5.2]
  def change
    add_column :plants, :foreman_id, :integer
  end
end
