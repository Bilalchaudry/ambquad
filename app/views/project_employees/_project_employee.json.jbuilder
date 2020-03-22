json.extract! project_employee, :id, :total_hours, :contract_start_date, :contract_end_date, :employee_id, :employee_type_id, :project_id, :created_at, :updated_at
json.url project_employee_url(project_employee, format: :json)
