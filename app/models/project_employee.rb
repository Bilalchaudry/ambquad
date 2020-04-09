class ProjectEmployee < ApplicationRecord
  after_create :time_sheet_employee
  belongs_to :employee
  belongs_to :employee_type
  belongs_to :project_company
  belongs_to :foreman, optional: true
  belongs_to :other_manager, optional: true

  has_many :project_project_employees
  has_many :projects, :through => :project_project_employees

  def time_sheet_employee
    EmployeeTimeSheet.create!(employee: self.employee.first_name + ' ' + self.employee.last_name,
                              labour_type: self.employee_type.employee_type,
                              project_company_id: self.project_company_id,
                              manager: self.other_manager.employee.first_name,
                              foreman_name: self.foreman.employee.first_name,
                              total_hours: self.total_hours,
                              employee_type_id: self.employee_type_id,
                              manager: self.foreman_id, employee_id: employee_id.to_i, project_id: self.project_id,
                              employee_create_date: Time.now.strftime("%Y-%m-%d"))
  end
end
