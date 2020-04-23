module CrewsHelper

  def crew_plants
    @crew_plants = @project.crews.get_all_plants(params[:id])
    @crews = @project.plants.reject { |plant| @crew_plants.pluck(:plant_id).include?(plant.id) }
  end

  def crew_employees
    @crew_employee = @project.crews.get_all_employees(params[:id])
    @crews = @project.employees.reject { |employee| @crew_employee.pluck(:employee_id).include?(employee.id) }
  end

end
