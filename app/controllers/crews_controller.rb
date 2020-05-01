class CrewsController < ApplicationController
  include CrewsHelper
  before_action :set_foreman, only: :new
  before_action :get_project, only: [:new, :show, :edit, :update, :create, :index, :plants_list, :employees_list, :destroy]


  # GET /crews
  # GET /crews.json
  def index
    @foremen = @project.foremen
  end

  # GET /crews/1
  # GET /crews/1.json
  def show
  end

  # GET /crews/new
  def new
    @crews = []
    if params[:plant].present?
      @crews = crew_plants
    else
      @crews = crew_employees
    end
    @crew = Crew.new
  end

  # GET /crews/1/edit
  def edit
  end

  # POST /crews
  # POST /crews.json
  def create
    @crew = []
    if params[:plant].present?
      params[:crew][:plant_ids].each do |plant_id|
        unless plant_id.empty?
          @project.crews.create(plant_id: plant_id.to_i, foreman_id: params[:foreman_id])
          Plant.find_by_id(plant_id.to_i).update(foreman_id: params[:foreman_id])
        end
      end
      respond_to do |format|
        format.html {redirect_to "/projects/#{@project.id}/crews/#{params[:foreman_id]}/plants_list", notice: 'Crew was successfully created.'}
        format.json {render :show, status: :created, location: @crew}
      end
    else
      params[:crew][:employee_ids].each do |employee_id|
        unless employee_id.empty?

          @project.crews.create(employee_id: employee_id.to_i, foreman_id: params[:foreman_id])
          Employee.find_by_id(employee_id.to_i).update(foreman_id: params[:foreman_id])
        end
      end
      respond_to do |format|
        format.html {redirect_to "/projects/#{@project.id}/crews/#{params[:foreman_id]}/employees_list", notice: 'Crew was successfully created.'}
        format.json {render :show, status: :created, location: @crew}
      end
    end
  end

  # PATCH/PUT /crews/1
  # PATCH/PUT /crews/1.json
  def update
    respond_to do |format|
      if @crew.update(crew_params)
        format.html {redirect_to @crew, notice: 'Crew was successfully updated.'}
        format.json {render :show, status: :ok, location: @crew}
      else
        format.html {render :edit}
        format.json {render json: @crew.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /crews/1
  # DELETE /crews/1.json
  def destroy
    begin
      @crew = @project.crews.find(params[:id])
      if @crew.plant_id.present?
        plant = Plant.find_by_id(@crew.plant_id)
        plant.update(foreman_id: nil) if plant.present?
      else
        employee = Employee.find_by_id(@crew.employee_id)
        employee.update(foreman_id: nil) if employee.present?
      end
      @crew.destroy
      @destroy = true
      respond_to do |format|
        format.js {
          flash[:notice] = 'Removed Successfully'
          render inline: "location.reload();" 
        }
      end
    rescue => e
      redirect_to project_crews_path, notice: e.message
    end
  end

  def plants_list
    @all_plants = @project.crews.get_all_plants(params[:id])
    @plants = @all_plants.where(foreman_id: params[:id])
  end

  def employees_list
    @all_plants = @project.crews.get_all_employees(params[:id])
    @employees = @all_plants.where(foreman_id: params[:id])
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_foreman
    @foreman_name = Employee.find(Foreman.find(params[:id]).employee_id).employee_name
  end

  def get_project
    @project = Project.find(params[:project_id])
  end

  # Only allow a list of trusted parameters through.
  def crew_params
    params.require(:crew).permit(project_id, employee_id, plant_id, foreman_id)
  end
end
