module ForemenHelper

  # def employe_except_foreman
  #   forman_ids = Foreman.all.pluck(:employee_id)
  #   @employees_except_foreman = Employee.all.where.not(id: forman_ids)
  # end

  # def client_company_projects_foreman
  #
  #   foreman_employee_ids = Foreman.all.pluck(:employee_id)
  #   project_ids = current_user.client_company.projects.pluck(:id) rescue nil
  #   client_company_project_employees = Employee.all.where(project_id: project_ids) rescue nil
  #   @client_company_project_foreman = client_company_project_employees.where(foreman_id: foreman_employee_ids) rescue nil
  # end
end
