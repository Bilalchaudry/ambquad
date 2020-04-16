class AddStatusToTemporaryUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :temporary_users, :status, :integer
  end
end
