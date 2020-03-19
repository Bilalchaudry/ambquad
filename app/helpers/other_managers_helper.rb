module OtherManagersHelper
  def employee_except_manager
    manager_ids = OtherManager.all.pluck(:employee_id)
    @employees_except_manager = Employee.all.where.not(id: manager_ids)
  end
end
