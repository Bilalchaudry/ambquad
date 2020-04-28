class AddClientCompanyIdToCostCode < ActiveRecord::Migration[5.2]
  def change
    add_column :cost_codes, :client_company_id, :integer
    add_column :cost_codes, :temporary_close, :boolean, default: false
  end
end
