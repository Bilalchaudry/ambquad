class ProjectProjectEmployee < ApplicationRecord
  belongs_to :project_employee
  belongs_to :project
end
