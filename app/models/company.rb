class Company < ApplicationRecord

  validates :email, :name, :phone_number, :address, :number_of_users, :start_date, presence: true
  has_many :projects
end
