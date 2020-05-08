class TimeSheetCostCode < ApplicationRecord
  audited

  belongs_to :employee_time_sheet, optional: :true

end
