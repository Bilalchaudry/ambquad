json.extract! project_company, :id, :company_summary, :project_role, :address, :phone, :primary_poc_first_name, :primary_poc_last_name, :poc_email, :poc_phone, :client_company_id, :project_id, :created_at, :updated_at
json.url project_company_url(project_company, format: :json)
