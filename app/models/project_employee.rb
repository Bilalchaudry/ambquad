class ProjectEmployee < ApplicationRecord
  belongs_to :employee
  belongs_to :employee_type
  belongs_to :project
end
