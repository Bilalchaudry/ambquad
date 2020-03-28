class Project < ApplicationRecord

  belongs_to :client_company

  has_many :cost_codes
  has_many :other_managers
  has_many :plants
  has_many :budget_holders
  has_many :plant_types
  has_many :user_projects
  has_many :employees
  has_many :employee_types
  has_many :foremen

  has_many :users, :through => :user_projects

  has_many :project_and_project_companies
  has_many :project_companies, :through => :project_and_project_companies

  has_many :project_project_employees
  has_many :project_employees, :through => :project_project_employees

  validates_uniqueness_of :project_name

end
