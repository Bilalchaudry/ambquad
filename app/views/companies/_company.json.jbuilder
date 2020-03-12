json.extract! company, :id, :email, :name, :phone_number, :address, :number_of_users, :start_date, :created_at, :updated_at
json.url company_url(company, format: :json)
