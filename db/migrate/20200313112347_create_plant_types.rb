class CreatePlantTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :plant_types do |t|
      t.string :type_name

      t.timestamps
    end
  end
end
