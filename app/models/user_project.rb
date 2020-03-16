class UserProject < ApplicationRecord

  belongs_to :client_company
  belongs_to :user

end
