class ClientCompany < ApplicationRecord
  has_many :users

  has_many :client_company_projects
  has_many :projects, :through => :client_company_projects

  validates :email, :name, :phone_number, :address, :number_of_users, :start_date, presence: true
end
