class ClientCompany < ApplicationRecord

  has_many :users
  has_many :budget_holders
  has_many :other_managers
  has_many :projects
  has_many :employees
  has_many :employee_types
  has_many :project_companies
  has_many :foremen
  has_many :cost_codes

  validates :phone, :address, :number_of_users, presence: true
  validates :company_name, :phone, uniqueness: true
end
