class AddCompanyNameToProjectCompany < ActiveRecord::Migration[5.2]
  def change
    add_column :project_companies, :company_name, :string
  end
end
