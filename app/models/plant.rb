class Plant < ApplicationRecord

  validates_uniqueness_of :plant_name

end
