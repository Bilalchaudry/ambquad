class AddLeadToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :project_lead, :string
  end
end
