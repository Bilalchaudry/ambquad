class AddColumnForEmailVarificationUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :email_confirmed, :boolean
    add_column :users, :confirm_token, :string
    add_column :temporary_users, :email_confirmed, :boolean
    add_column :temporary_users, :confirm_token, :string
  end
end
