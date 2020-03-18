class Project < ApplicationRecord

  has_many :client_company_projects, dependent: :destroy
  has_many :client_companies, :through => :client_company_projects, dependent: :destroy

  has_many :user_projects
  has_many :users, :through => :user_projects
  has_many :project_employees

  validates_uniqueness_of :project_name

end
