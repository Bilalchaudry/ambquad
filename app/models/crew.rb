class Crew < ApplicationRecord

  scope :get_all_plants, -> { where.not(plant_id: nil) }
  scope :get_all_employees, -> { where.not(employee_id: nil) }


  belongs_to :project

  has_many :foremen
  belongs_to :employee, optional: true
  belongs_to :plant, optional: true

end
