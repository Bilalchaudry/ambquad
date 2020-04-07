class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_projects
  has_many :projects, :through => :user_projects


  belongs_to :client_company
  validates :email, uniqueness: true

  enum role: {
      User: 0,
      Admin: 1
  }

  enum status: {
      Active: 0,
      Inactive: 1
  }

end
