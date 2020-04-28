class AddStateCityToProjectEmployee < ActiveRecord::Migration[5.2]
  def change
    add_column :project_companies, :state, :string
    add_column :project_companies, :city, :string
  end
end
