class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :project_name
      t.string :project_id
      t.string :site_office_address
      t.text :project_summary
      t.text :phone
      t.date :start_date
      t.date :end_date
      t.integer :project_status
      t.integer :client_company_id
      t.string :client_po_number
      t.date :closed_at
      t.timestamps
    end
  end
end
