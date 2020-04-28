class AddClientCompanyIdToForeman < ActiveRecord::Migration[5.2]
  def change
    add_column :foremen, :client_company_id, :integer
  end
end
