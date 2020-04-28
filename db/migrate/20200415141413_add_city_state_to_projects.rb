class AddCityStateToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :city, :string
    add_column :projects, :state, :string
  end
end
