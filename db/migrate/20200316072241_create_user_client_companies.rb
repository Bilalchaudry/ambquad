class CreateUserClientCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :user_client_companies do |t|
      t.integer :user_id
      t.integer :client_company_id
      t.timestamps
    end
  end
end
