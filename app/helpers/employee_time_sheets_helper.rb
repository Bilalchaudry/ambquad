module EmployeeTimeSheetsHelper
  def sort_cost_codes(cost_codes_array)
    @cost_codes = cost_codes_array.sort_by do |cost_code|
      cost_code[:created_at]
    end
  end
  def employee_total_hours_cost_code_sum(employe_time_sheet_id)
    @cost_codes = @project.time_sheet_cost_codes.where(employee_time_sheet_id: employe_time_sheet_id).to_a
    @cost_code_and_total_hours_sum = 0
    for i in 0..4
      if @cost_codes[i].present?
        @cost_code_and_total_hours_sum += @cost_codes[i].hrs
      end
    end
  end

  def plant_total_hours_cost_code_sum(plant_time_sheet_id)
    @cost_codes = @project.time_sheet_cost_codes.where(plant_time_sheet_id: plant_time_sheet_id).to_a
    @cost_code_and_total_hours_sum = 0
    for i in 0..4
      if @cost_codes[i].present?
        @cost_code_and_total_hours_sum += @cost_codes[i].hrs
      end
    end
  end

  def cost_code_sum(employee_time_sheet)
    @cost_codes = employee_time_sheet.time_sheet_cost_codes
    @cost_code_and_total_hours_sum = @cost_codes.sum(:hrs) rescue 0
  end

  def weekly_cost_codes(employee)
    @employee_cost_codes = @cost_codes.where(employee_id: employee.id)
  end

  def cost_code_time_sheet_id_employee(cost_code_id, employee_time_sheet_id)
    @cost_code_id = cost_code_id
    @cost_code_time_sheet_id = @project.time_sheet_cost_codes.where(cost_code_id: @cost_code_id, employee_time_sheet_id: employee_time_sheet_id).ids
  end

  def cost_code_time_sheet_id_plants(cost_code_id, plant_time_sheet_id)
    @cost_code_id = cost_code_id
    @cost_code_time_sheet_id = @project.time_sheet_cost_codes.where(cost_code_id: @cost_code_id, plant_time_sheet_id: plant_time_sheet_id).ids
  end

  def employee_codes_of_specific_date(employee_time_sheet_id, sun, monday, tuesday, wednesday, thursday, friday, sat)
    @cost_codes = @project.time_sheet_cost_codes.where(employee_time_sheet_id: employee_time_sheet_id)
    @sunday_cost_code = @cost_codes.find_by(cost_code_created_at: sun)
    @monday_cost_code = @cost_codes.find_by(cost_code_created_at: monday)
    @tue_cost_code = @cost_codes.find_by(cost_code_created_at: tuesday)
    @wed_cost_code = @cost_codes.find_by(cost_code_created_at: wednesday)
    @thur_cost_code = @cost_codes.find_by(cost_code_created_at: thursday)
    @fri_cost_code = @cost_codes.find_by(cost_code_created_at: friday)
    @saturday_cost_code = @cost_codes.find_by(cost_code_created_at: sat)
  end

  def employee_cost_codes(day, employee)
    @cost_code = @project.time_sheet_cost_codes.where(cost_code_created_at: day, employee_id: employee.id)
    # if employee_time_sheet
    #   @cost_code = employee_time_sheet.time_sheet_cost_codes.find_by(cost_code_created_at: day)
    # end
  end

  def plant_cost_codes(day, employee)
    @cost_code = @project.time_sheet_cost_codes.where(cost_code_created_at: day, plant_id: employee.id)
    # if employee_time_sheet
    #   @cost_code = employee_time_sheet.time_sheet_cost_codes.find_by(cost_code_created_at: day)
    # end
  end
end
