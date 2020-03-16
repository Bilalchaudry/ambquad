json.extract! temporary_user, :id, :first_name, :last_name, :phone_no, :email, :username, :role, :encrypted_password, :company_id, :created_at, :updated_at
json.url temporary_user_url(temporary_user, format: :json)
