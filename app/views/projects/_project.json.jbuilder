json.extract! project, :id, :project_name, :address, :project_lead, :created_at, :updated_at
json.url project_url(project, format: :json)
