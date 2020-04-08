json.extract! project_plant, :id, :plant_id, :plant_type_id, :project_company_id, :contract_start_date, :contract_end_date, :foreman_id, :other_manager_id, :status, :client_company_id, :created_at, :updated_at
json.url project_plant_url(project_plant, format: :json)
