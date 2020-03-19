class CreateProjectCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :project_companies do |t|
      t.text :company_summary
      t.text :project_role
      t.string :address
      t.string :phone
      t.string :primary_poc_first_name
      t.string :primary_poc_last_name
      t.string :poc_email
      t.string :poc_phone
      t.references :client_company, foreign_key: true
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
