class RemoveCompanyIdFromCompany < ActiveRecord::Migration[5.2]
  def change
    remove_column :companies, :company_id, :bigint
  end
end
