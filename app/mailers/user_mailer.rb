class UserMailer < ApplicationMailer
  default :from => "team@ambquad.com"


  def registration_confirmation(user)
    @user = user
    mail(:to => user.email, :subject => "Registration Confirmation for Awesome App")
  end
end