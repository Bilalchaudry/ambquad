class AddOtherManagerToEmployee < ActiveRecord::Migration[5.2]
  def change
    add_reference :employees, :other_manager, foreign_key: true
  end
end
