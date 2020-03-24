class EmployeeType < ApplicationRecord

  belongs_to :client_company
  validates :employee_type, presence: true, uniqueness: true
end
