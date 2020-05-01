module CrewsHelper

  def crew_plants
    @crew_plants = @project.crews.get_all_plants(params[:id])
    @crews = @project.plants.reject { |plant| @crew_plants.pluck(:plant_id).include?(plant.id) }
  end

  def crew_employees
    @crew_employee = @project.crews.get_assigned_employees(params[:id])
    crew_forman_employee_id = @project.foremen.find(params[:id]).employee_id
    @crews = @project.employees.where("id != ?", crew_forman_employee_id).reject { |employee| @crew_employee.pluck(:employee_id).include?(employee.id) }
  end

end
