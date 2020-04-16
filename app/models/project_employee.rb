class ProjectEmployee < ApplicationRecord
  audited
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
                              manager: self.other_manager.employee.first_name + ' ' + self.other_manager.employee.last_name,
                              foreman_name: self.foreman.employee.first_name + ' ' + self.foreman.employee.last_name,
                              total_hours: 0,
                              employee_type_id: self.employee_type_id,
                              employee_id: employee_id.to_i, project_id: self.project_id,
                              employee_create_date: Time.now.strftime("%Y-%m-%d"))
  end
end
