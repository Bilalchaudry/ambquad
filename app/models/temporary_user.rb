class TemporaryUser < ApplicationRecord

  enum role: {
      "Admin": 0,
      "User": 1,
      "Client": 2
  }

end
