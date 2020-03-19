class Employee < ApplicationRecord
  belongs_to :project
  belongs_to :project_company
  enum gender: {
      Male: 0,
      Female: 1
  }
  enum status: {
      Active: 0,
      Onhold: 1,
      Closed: 2
  }

end
