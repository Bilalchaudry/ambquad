require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

# scheduler.in '1s' do
#   Project.all.each do |project|
#     date = Date.today
#     time_sheet = project.employee_time_sheets.where(employee_create_date: date)
#
#     if date.friday?
#       project_employees = project.employees
#       employee_time_sheets = []
#       cost_codes = []
#       begin
#         if project_employees.present?
#           project_employees.each do |employee|
#
#             manager_name = employee.other_managers.employee.employee_name rescue nil
#             foreman_name = employee.foreman.employee.employee_name rescue nil
#             company_name = employee.project_company.company_name rescue nil
#
#             employee_time_sheets << project.employee_time_sheets.new(employee: employee.employee_name, labour_type: employee.employee_type.employee_type,
#                                                                      project_company_id: employee.project_company_id, company: company_name,
#                                                                      manager: manager_name, foreman_name: foreman_name, foreman_id: employee.foreman_id,
#                                                                      total_hours: 0, employee_type_id: employee.employee_type_id,
#                                                                      employee_create_date: date, project_id: project.id, employee_id: employee.employee_id)
#
#             new_cost_codes = []
#             employee_cost_codes = project.time_sheet_cost_codes.where(employee_id: employee.id, created_at: date)
#
#
#             employee_cost_codes.each do |cost_code|
#               new_cost_codes << project.time_sheet_cost_codes.new(cost_code_id: cost_code.cost_code_id, cost_code: cost_code.cost_code,
#                                                                   employee_id: cost_code.employee_id, hrs: cost_code.hrs,
#                                                                   time_sheet_employee_id: employee.id)
#             end
#
#           end
#           # EmployeeTimeSheet.import employee_time_sheets
#           TimeSheetCostCode.import new_cost_codes
#         else
#           next
#         end
#       rescue => e
#         e.message
#       end
#     end
#   end
# end