class AddExtraAttributesToCostCodes < ActiveRecord::Migration[5.2]
  def change
    add_column :cost_codes, :WBS_01, :string
    add_column :cost_codes, :WBS_01_Description, :string

    add_column :cost_codes, :WBS_02, :string
    add_column :cost_codes, :WBS_02_Description, :string

    add_column :cost_codes, :WBS_03, :string
    add_column :cost_codes, :WBS_03_Description, :string

    add_column :cost_codes, :WBS_04, :string
    add_column :cost_codes, :WBS_04_Description, :string

    add_column :cost_codes, :WBS_05, :string
    add_column :cost_codes, :WBS_05_Description, :string
  end
end
