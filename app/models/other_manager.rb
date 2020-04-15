class OtherManager < ApplicationRecord
  audited
  belongs_to :employee
  belongs_to :project

  validates_uniqueness_of :employee_id, :scope => :project_id

end
