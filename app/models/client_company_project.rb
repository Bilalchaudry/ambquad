class ClientCompanyProject < ApplicationRecord
  audited
  belongs_to :client_company
  belongs_to :project
end
