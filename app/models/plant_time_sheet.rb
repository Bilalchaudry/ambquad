class PlantTimeSheet < ApplicationRecord
  audited

  belongs_to :project
  belongs_to :plant
  belongs_to :employee, optional: :true
  belongs_to :project_company, optional: :true
  belongs_to :foreman, optional: :true
  has_many :time_sheet_cost_codes, dependent: :destroy
end
