class Crew < ApplicationRecord

  has_many :foremen
  belongs_to :project
  belongs_to :employee, optional: true
  belongs_to :plant, optional: true


  scope :get_all_plants, -> (id) { where.not(plant_id: nil) }
  scope :get_all_employees, -> (id) { where.not(employee_id: nil).where(foreman_id: id) }
  scope :get_assigned_employees, -> (id) { where.not(employee_id: nil) }

end
