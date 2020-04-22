module CrewsHelper

  def plants_list
    @all_plants = @project.crews.get_all_plants
    @plants = @all_plants.where(foreman_id: params[:id], project_id: @project.id).to_a
  end

  def employees_list
    @all_plants = @project.crews.get_all_employees
    @employees = @all_plants.where(foreman_id: params[:id], project_id: @project.id).to_a
  end

end
