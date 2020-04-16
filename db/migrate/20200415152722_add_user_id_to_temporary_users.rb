class AddUserIdToTemporaryUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :user_id, :string
    add_column :temporary_users, :user_id, :string
  end
end
