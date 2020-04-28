class ProjectPlant < ApplicationRecord
  audited
  belongs_to :plant
  belongs_to :plant_type
  belongs_to :project
  belongs_to :project_company

end
