class AddColumnForActiveUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :temporary_users, :active_user, :boolean, :default => true
    add_column :users, :active_user, :boolean, :default => true
  end
end
