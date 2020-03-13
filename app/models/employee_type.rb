class EmployeeType < ApplicationRecord
  validates :employee_type, presence: true, uniqueness: true
end
