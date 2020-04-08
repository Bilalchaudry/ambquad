class AddForemanStartDateToProjectPlants < ActiveRecord::Migration[5.2]
  def change
    add_column :project_plants, :foreman_start_date, :date
    add_column :project_plants, :foreman_end_date, :date
  end
end
