class ProjectCompany < ApplicationRecord
  belongs_to :client_company
  belongs_to :project
  has_many :employees
  has_many :project_and_project_companies
  has_many :projects, :through => :project_and_project_companies, dependent: :destroy
end