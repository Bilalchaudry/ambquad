class UserMailer < ApplicationMailer
  default :from => "khurramrashid.novatore@gmail.com"


  def registration_confirmation(user)
    @user = user
    mail(:to => user.email, :subject => "Registration Confirmation for Awesome App")
  end
end