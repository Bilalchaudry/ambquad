class ProjectEmployee < ApplicationRecord
  audited
  belongs_to :employee
  belongs_to :employee_type
  belongs_to :project_company
  belongs_to :foreman, optional: true
  belongs_to :other_manager, optional: true

  has_many :project_project_employees
  has_many :projects, :through => :project_project_employees
end
