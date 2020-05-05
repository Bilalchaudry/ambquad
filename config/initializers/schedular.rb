require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.in '1s' do
  Project.all.each do |project|
    date = Date.today
    employee_create_date = date
    if date.tuesday?
      if project.employee_time_sheets.present?
        (1..6).to_a.reverse.each do |day|
          employee_create_date = employee_create_date + 1
          search_date = employee_create_date - 7
          project.employees.where.not(foreman_id: nil).each do |employee|
            create_time_sheet_employee(project, employee, search_date, employee_create_date)
          end
        end
      elsif project.project_companies.present? &&
          project.employees.present? && project.employees.where(foreman_id: nil).blank? &&
          project.plants.present? && project.plants.where(foreman_id: nil).blank? &&
          project.foremen.present? &&
          project.budget_holders.present? &&
          project.cost_codes.present? && project.cost_codes.where(budget_holder_id: nil).blank? &&
          project.crews.present?

        (1..6).to_a.reverse.each do |day|

          project_employees = project.employees
          if project_employees.present?
            employee_create_date = employee_create_date + 1
            search_date = employee_create_date - 7

            project_employees.each do |employee|
              create_time_sheet_employee(project, employee, search_date, employee_create_date)
            end
          end

        end
      end
    end
  end

  def create_time_sheet_employee(project, employee, search_date, employee_create_date)
    manager_name = employee.other_managers.employee.employee_name rescue nil
    foreman_name = employee.foreman.employee.employee_name rescue nil
    company_name = employee.project_company.company_name rescue nil


    previous_employee_time_sheet = project.employee_time_sheets.where(employee_id: employee.id,
                                                                      employee_create_date: search_date).first

    sheet_hours = previous_employee_time_sheet.total_hours rescue 0
    employee_time_sheets = project.employee_time_sheets.create(employee: employee.employee_name, labour_type: employee.employee_type.employee_type,
                                                               project_company_id: employee.project_company_id, company: company_name,
                                                               manager: manager_name, foreman_name: foreman_name, foreman_id: employee.foreman_id,
                                                               total_hours: sheet_hours, employee_type_id: employee.employee_type_id,
                                                               employee_create_date: employee_create_date, project_id: project.id, employee_id: employee.id)

    if previous_employee_time_sheet.present?
      employee_cost_codes = previous_employee_time_sheet.time_sheet_cost_codes.where(employee_time_sheet_id: previous_employee_time_sheet.id)

      employee_cost_codes.each do |cost_code|
        project.time_sheet_cost_codes.create(cost_code_id: cost_code.cost_code_id, cost_code: cost_code.cost_code,
                                             employee_id: cost_code.employee_id, hrs: cost_code.hrs,
                                             employee_time_sheet_id: employee_time_sheets.id)

      end
    end
  end
end

# scheduler.in '1m' do
#   if Date.today.monday?
#     EmployeeTimeSheet.where("created_at > ?", 7.days.ago).where(submit_sheet: false).update(submit_sheet: true)
#   end
#
# end