class EmployeeTimeSheet < ApplicationRecord
  audited

  has_many :time_sheet_cost_codes, dependent: :destroy
  belongs_to :project
end
