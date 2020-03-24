class Project < ApplicationRecord

  belongs_to :client_company
  has_many :cost_codes
  has_many :user_projects
  has_many :users, :through => :user_projects
  has_many :project_employees
  has_many :project_companies, :through => :project_and_project_companies, dependent: :destroy
  has_many :project_and_project_companies
  has_many :employees
  validates_uniqueness_of :project_name

end
