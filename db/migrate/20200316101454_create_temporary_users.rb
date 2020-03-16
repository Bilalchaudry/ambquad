class CreateTemporaryUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :temporary_users do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone_no
      t.string :email
      t.string :username
      t.integer :role, default: 0
      t.string :encrypted_password
      t.string :password
      t.integer :company_id

      t.timestamps
    end
  end
end
