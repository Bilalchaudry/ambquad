class ClientCompany < ApplicationRecord

  has_many :users
  has_many :budget_holders

  has_many :client_company_projects, dependent: :destroy
  has_many :projects, :through => :client_company_projects, dependent: :destroy
  has_many :employees

  validates :phone, :address, :number_of_users, presence: true
  validates :company_name, :phone, uniqueness: true
end
