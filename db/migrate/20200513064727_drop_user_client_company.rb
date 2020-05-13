class DropUserClientCompany < ActiveRecord::Migration[5.2]
  def change
    drop_table :user_client_companies
  end
end
