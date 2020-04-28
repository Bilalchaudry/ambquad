class AddCityStateToTemporaryUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :temporary_users, :city, :string
    add_column :temporary_users, :state, :string
  end
end
