class PlantTimeSheet < ApplicationRecord
  audited
  belongs_to :plant
  belongs_to :project
end
