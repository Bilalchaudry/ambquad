class ChangePhoneToBeStringInEmployee < ActiveRecord::Migration[5.2]
  def change
    change_column :employees, :phone, :string
  end
end
