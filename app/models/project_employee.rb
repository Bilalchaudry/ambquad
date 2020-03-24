class ProjectEmployee < ApplicationRecord
  belongs_to :employee
  belongs_to :employee_type
  belongs_to :project
  belongs_to :foreman, optional: true
  belongs_to :other_manager, optional: true

end
