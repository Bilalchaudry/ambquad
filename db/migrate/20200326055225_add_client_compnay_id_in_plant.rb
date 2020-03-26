class AddClientCompnayIdInPlant < ActiveRecord::Migration[5.2]
  def change
    add_column :plants, :client_company_id, :integer
    add_column :plant_types, :client_company_id, :integer
  end
end
