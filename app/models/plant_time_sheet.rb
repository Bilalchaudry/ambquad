class PlantTimeSheet < ApplicationRecord
  audited
  belongs_to :plant
end
