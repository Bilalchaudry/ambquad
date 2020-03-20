class AddDateToPlants < ActiveRecord::Migration[5.2]
  def change
    add_column :plants, :foreman_start_date, :date
    add_column :plants, :foreman_end_date, :date
  end
end
