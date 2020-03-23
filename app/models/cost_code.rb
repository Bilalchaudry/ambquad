class CostCode < ApplicationRecord

  belongs_to :project, optional: true

  validates_uniqueness_of :cost_code_id

end
