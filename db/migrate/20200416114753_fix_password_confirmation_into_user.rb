class FixPasswordConfirmationIntoUser < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :confirm_password, :password_confirmation
    add_column :temporary_users, :password_confirmation, :string

  end
end
