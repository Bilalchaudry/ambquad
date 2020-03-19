module EmployeesHelper
  def client_company_project_employees
    project_ids = current_user.client_company.projects.pluck(:id)
    @client_company_project_employees = Employee.all.where(project_id: project_ids)
  end
end
