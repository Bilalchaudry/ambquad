json.extract! plant, :id, :plant_name, :plant_id, :plant_type, :project_company_id, :contract_start_date, :contract_end_date, :market_value, :status, :created_at, :updated_at
json.url plant_url(plant, format: :json)
