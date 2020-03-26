class TemporaryUser < ApplicationRecord
  validates :email, uniqueness: true
  belongs_to :client_company, optional: true
  enum role: {
      Admin: 0,
      User: 1,
      Client: 2
  }

end
