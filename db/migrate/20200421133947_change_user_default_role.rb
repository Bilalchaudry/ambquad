class ChangeUserDefaultRole < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :role, :integer, :default => nil
    change_column :temporary_users, :role, :integer, :default => nil
  end
end
