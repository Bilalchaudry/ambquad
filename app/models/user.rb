class User < ApplicationRecord
  audited

  devise :database_authenticatable, :registerable,
          :rememberable, :validatable, :recoverable ,:confirmable

  has_many :user_projects
  has_many :projects, :through => :user_projects
  belongs_to :client_company

  auto_strip_attributes :username
  validates_uniqueness_of :email, :username, uniqueness: true, :case_sensitive => false


  enum role: {
      Admin: 0,
      User: 1
  }

  enum status: {
      Active: 0,
      Inactive: 1
  }


  def validate_email
    self.email_confirmed = true
    self.confirm_token = nil
  end

  # validates :password, :presence =>true, :confirmation =>true
  # validates_confirmation_of :password

end
