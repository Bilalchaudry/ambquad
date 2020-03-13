class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :project_name
      t.string :address
      t.string :project_lead

      t.timestamps
    end
  end
end
