class PlantTimeSheet < ApplicationRecord
  audited
  has_many :plants
end
