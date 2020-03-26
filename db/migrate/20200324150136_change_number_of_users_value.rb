class ChangeNumberOfUsersValue < ActiveRecord::Migration[5.2]
  def change
    change_column :client_companies, :number_of_users ,:integer, default: 0
  end
end
