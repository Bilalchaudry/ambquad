class AddClinetCompanyIdToOtherManager < ActiveRecord::Migration[5.2]
  def change
    add_column :other_managers, :client_company_id, :integer
  end
end
