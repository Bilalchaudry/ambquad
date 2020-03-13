class PlantType < ApplicationRecord
  validates :type_name, presence: true, uniqueness: true
end
