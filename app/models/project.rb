class Project < ApplicationRecord
  belongs_to :company
  validates_uniqueness_of :project_name

end
