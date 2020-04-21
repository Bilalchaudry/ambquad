class User < ApplicationRecord
  audited

  devise :database_authenticatable, :registerable,
          :rememberable, :validatable, :confirmable

  has_many :user_projects
  has_many :projects, :through => :user_projects
  belongs_to :client_company

  enum role: {
      User: 0,
      Admin: 1
  }

  enum status: {
      Active: 0,
      Inactive: 1
  }


  def set_confirmation_token
    if self.confirm_token.blank?
      self.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
  end

  def validate_email
    self.email_confirmed = true
    self.confirm_token = nil
  end

  validates :email, :username, uniqueness: true, :case_sensitive => false
  # validates :password, :presence =>true, :confirmation =>true
  # validates_confirmation_of :password

end
