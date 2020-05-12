class TimeSheetCostCode < ApplicationRecord
  audited

  belongs_to :employee_time_sheet, optional: :true
  belongs_to :plant_time_sheet, optional: :true

end
