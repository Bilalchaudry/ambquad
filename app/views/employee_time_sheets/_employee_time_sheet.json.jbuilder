json.extract! employee_time_sheet, :id, :employee, :employee_id, :labour_type, :employee_type_id, :company, :project_company_id, :manager, :foreman_id, :total_hours, :created_at, :updated_at
json.url employee_time_sheet_url(employee_time_sheet, format: :json)
