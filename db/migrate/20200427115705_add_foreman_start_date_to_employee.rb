class AddForemanStartDateToEmployee < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :foreman_start_date, :date
    add_column :employees, :foreman_end_date, :date
  end
end
