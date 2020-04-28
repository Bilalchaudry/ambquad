class CreateClientCompanyProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :client_company_projects do |t|
      t.integer :project_id
      t.integer :client_company_id
      t.timestamps
    end
  end
end
