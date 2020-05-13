require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '1d' do
  if Date.today.monday?
    EmployeeTimeSheet.where("timesheet_created_at < ?", (Date.today - 1)).where(submit_sheet: false).update(submit_sheet: true)
    PlantTimeSheet.where("timesheet_created_at < ?", (Date.today - 1)).where(submit_sheet: false).update(submit_sheet: true)
  end

end
scheduler.cron '1,00 * * * *' do
  Project.all.each do |project|
    @project_employees_without_foreman = project.employees.where(foreman_id: nil)
    @project_plants_without_foreman = project.plants.where(foreman_id: nil)
    @project_cost_codes_without_budget_holder = project.cost_codes.where(budget_holder_id: nil)
    if @project_employees_without_foreman.present? || @project_plants_without_foreman.present? || @project_cost_codes_without_budget_holder.present?
      @project_name = project.project_name
      subject = @project_name + ' ' + ' data is incomplete.'
      project_users = project.client_company.users
      project_users.each do |project_user|
        NotificationMailer.notification(@project_name,subject,project_user.username,project_user.email).deliver_now
      end
    end
  end
end