class NotificationJob < ApplicationJob
  queue_as :default

  def perform(project_name,subject,project_user, user_email)
    NotificationMailer.notification(project_name,subject,project_user,user_email).deliver_now
  end
end
