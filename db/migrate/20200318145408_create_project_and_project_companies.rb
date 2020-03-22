class CreateProjectAndProjectCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :project_and_project_companies do |t|
      t.references :project, foreign_key: true
      t.references :project_company, foreign_key: true

      t.timestamps
    end
  end
end
