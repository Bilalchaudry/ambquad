class NotificationMailer < ApplicationMailer
  default :from => "team@ambquad.com"
  def notification(project_name,subject,project_user_name, user_email)
    @project_name = project_name
      @user_name = project_user_name
      mail(to: user_email, subject: subject)
  end
end
