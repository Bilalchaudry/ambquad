class CreateClientCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :client_companies do |t|
      t.string :email
      t.string :company_name
      t.string :company_id
      t.string :address
      t.string :phone
      t.integer :number_of_users
      t.integer :primary_poc_first_name
      t.integer :primary_poc_last_name
      t.integer :poc_email
      t.integer :poc_phone
      t.integer :status
      t.date :closed_at
      t.timestamps
    end
  end
end
