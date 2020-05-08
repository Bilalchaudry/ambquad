class EmployeeTimeSheet < ApplicationRecord
  audited

  has_many :time_sheet_cost_codes, dependent: :destroy
  belongs_to :project
  # belongs_to :employee, optional: :true
  belongs_to :project_company, optional: :true

end
