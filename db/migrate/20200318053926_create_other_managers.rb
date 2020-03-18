class CreateOtherManagers < ActiveRecord::Migration[5.2]
  def change
    create_table :other_managers do |t|
      t.string :type
      t.references :employee, foreign_key: true

      t.timestamps
    end
  end
end
