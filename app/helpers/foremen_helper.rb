module ForemenHelper
  def employe_except_foreman
    forman_ids = Foreman.all.pluck(:id)
    @employees_except_foreman =Employee.all.where.not(id: forman_ids)
  end
end
