class AddClientCompanyToProject < ActiveRecord::Migration[5.2]
  def change
    add_reference :projects, :client_company, foreign_key: true
  end
end
