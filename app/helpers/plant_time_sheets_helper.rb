module PlantTimeSheetsHelper
  def sort_plant_cost_codes(cost_codes_array)
    @cost_codes = cost_codes_array.sort_by do |cost_code|
      cost_code[:created_at]
    end
  end

  # def checking_cost_code_and_total_hours(plant_time_sheet_id)
  #   @cost_codes = @project.time_sheet_cost_codes.where(time_sheet_plant_id: plant_time_sheet_id)
  #   @cost_codes_ar = @cost_codes.to_a
  #   @cost_code_and_total_hours_sum = 0
  #   for i in 0..4
  #     if @cost_codes[i].present?
  #       @cost_code_and_total_hours_sum += @cost_codes[i].hrs
  #     end
  #   end
  # end

  def cost_code_time_sheet_id(cost_code_id, plant_time_sheet_id)
    @cost_code_id = cost_code_id
    @cost_code_time_sheet_id = @cost_codes.where(cost_code_id: @cost_code_id, time_sheet_plant_id: plant_time_sheet_id).ids
  end

    # def cost_codes_of_specific_date(plant_time_sheet_id,sunday, monday,tuesday,wednesday,thursday,friday, saturday)
    #   @cost_codes = @project.time_sheet_cost_codes.where(time_sheet_plant_id: plant_time_sheet_id)
    #   @sunday_cost_code = @cost_codes.find_by(cost_code_created_at: sunday)
    #   @monday_cost_code = @cost_codes.find_by(cost_code_created_at: monday)
    #   @tue_cost_code = @cost_codes.find_by(cost_code_created_at: tuesday)
    #   @wed_cost_code = @cost_codes.find_by(cost_code_created_at: wednesday)
    #   @thur_cost_code = @cost_codes.find_by(cost_code_created_at: thursday)
    #   @fri_cost_code = @cost_codes.find_by(cost_code_created_at: friday)
    #   @sat_cost_code = @cost_codes.find_by(cost_code_created_at: saturday)
    #   end
end
