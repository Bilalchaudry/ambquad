class CostCode < ApplicationRecord

  belongs_to :project

  validates_uniqueness_of :cost_code_id

end
