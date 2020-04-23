class TemporaryUser < ApplicationRecord
  belongs_to :client_company, optional: true
  enum role: {
      Admin: 0,
      User: 1,
      Client: 2
  }

  def confirm_email
    user = User.find_by_confirm_token(params[:token])
    if user
      user.validate_email
      user.save(validate: false)
      redirect_to user
    else
      flash[:error] = "Sorry. User does not exist"
      redirect_to root_url
    end
  end


  def set_confirmation_token
    if self.confirm_token.blank?
      self.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
  end

  def validate_email
    self.email_confirmed = true
    self.confirm_token = nil
  end

  validates_uniqueness_of :email, :username, uniqueness: true, :case_sensitive => false
  validates :password, :presence =>true, :confirmation =>true
  validates_confirmation_of :password

end
