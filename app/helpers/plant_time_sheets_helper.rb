module PlantTimeSheetsHelper
  def checking_cost_code_and_total_hours(plant_time_sheet_id)
    @cost_codes = @project.time_sheet_cost_codes.where(time_sheet_plant_id: plant_time_sheet_id)
    @cost_codes_ar = @cost_codes.to_a
    @cost_code_and_total_hours_sum = 0
    for i in 0..4
      if @cost_codes[i].present?
        @cost_code_and_total_hours_sum += @cost_codes[i].hrs
      end
    end
  end

  def cost_code_time_sheet_id(cost_code_id, plant_time_sheet_id)
    @cost_code_id = cost_code_id
    @cost_code_time_sheet_id = @cost_codes.where(cost_code_id: @cost_code_id, time_sheet_plant_id: plant_time_sheet_id).ids
  end
end
