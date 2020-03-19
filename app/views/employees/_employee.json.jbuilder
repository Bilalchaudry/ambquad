json.extract! employee, :id, :first_name, :last_name, :employee_id, :phone, :email, :gender, :home_company_role, :contract_start_date, :contract_end_date, :status, :project_company_id, :project_id, :created_at, :updated_at
json.url employee_url(employee, format: :json)
