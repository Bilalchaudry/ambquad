class CreateClientCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :client_companies do |t|
      t.string :email
      t.string :name
      t.string :phone_number
      t.string :address
      t.integer :number_of_users
      t.date :start_date

      t.timestamps
    end
  end
end
