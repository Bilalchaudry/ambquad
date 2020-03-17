class TemporaryUser < ApplicationRecord
  validates :email, uniqueness: true
  enum role: {
      Admin: 0,
      User: 1,
      Client: 2
  }

end
