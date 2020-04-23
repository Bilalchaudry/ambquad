module EmployeeTimeSheetsHelper
  def employee_total_hours_cost_code_sum(employe_time_sheet_id)
    @cost_codes = @project.time_sheet_cost_codes.where(employee_time_sheet_id: employe_time_sheet_id).to_a
    @cost_code_and_total_hours_sum = 0
    for i in 0..4
      if @cost_codes[i].present?
        @cost_code_and_total_hours_sum += @cost_codes[i].hrs
      end
    end
  end
end
