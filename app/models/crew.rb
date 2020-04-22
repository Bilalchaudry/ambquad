class Crew < ApplicationRecord

  belongs_to :project

  has_many :foremen
  belongs_to :employee, optional: true
  belongs_to :plant, optional: true

end
