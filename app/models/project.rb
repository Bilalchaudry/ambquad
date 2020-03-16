class Project < ApplicationRecord

  has_many :client_company_projects
  has_many :client_companies, :through => :client_company_projects

end
