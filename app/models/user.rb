class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  belongs_to :client_company, optional: true

  enum role: {
      Admin: 0,
      User: 1,
      Client: 2
  }
end
