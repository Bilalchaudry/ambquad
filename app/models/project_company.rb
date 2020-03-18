class ProjectCompany < ApplicationRecord
  belongs_to :client_company
  belongs_to :project
end
