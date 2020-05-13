require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '1d' do
  if Date.today.monday?
    EmployeeTimeSheet.where("timesheet_created_at < ?", (Date.today - 1)).where(submit_sheet: false).update(submit_sheet: true)
    PlantTimeSheet.where("timesheet_created_at < ?", (Date.today - 1)).where(submit_sheet: false).update(submit_sheet: true)
  end

end