class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_client_companies
  has_many :client_companies, :through => :user_client_companies

  # belongs_to :client_company, optional: true

  enum role: {
      Admin: 0,
      User: 1,
      Client: 2
  }
end
