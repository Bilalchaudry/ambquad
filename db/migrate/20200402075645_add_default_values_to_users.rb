class AddDefaultValuesToUsers < ActiveRecord::Migration[5.2]
  def change
    change_column_default :users, :email_confirmed,  false
    change_column_default :temporary_users, :email_confirmed,  false
  end
end
