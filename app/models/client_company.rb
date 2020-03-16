class ClientCompany < ApplicationRecord
  has_many :users

  has_many :client_company_projects
  has_many :projects, :through => :client_company_projects

  validates :phone, :address, :number_of_users, presence: true
end
