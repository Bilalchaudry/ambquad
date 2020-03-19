class CreateForemen < ActiveRecord::Migration[5.2]
  def change
    create_table :foremen do |t|
      t.references :employee, foreign_key: true

      t.timestamps
    end
  end
end
