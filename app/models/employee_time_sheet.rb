class EmployeeTimeSheet < ApplicationRecord
  belongs_to :project
  audited
end
