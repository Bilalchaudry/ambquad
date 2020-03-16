class Company < ApplicationRecord

  has_many :projects
  has_many :users

  validates :email, :name, :phone_number, :address, :number_of_users, :start_date, presence: true
  validates_uniqueness_of :email, :name

end
