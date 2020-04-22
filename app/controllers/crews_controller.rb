class CrewsController < ApplicationController
  include CrewsHelper
  # before_action :set_crew, only: [:show, :edit, :update, :destroy]
  before_action :get_project, only: [:new, :show, :edit, :update, :create, :index, :plants_list, :employees_list, :destroy]


  # GET /crews
  # GET /crews.json
  def index
    @crews = @project.foremen
  end

  # GET /crews/1
  # GET /crews/1.json
  def show
  end

  # GET /crews/new
  def new
    @crews = []
    if params[:plant].present?
      @crew_plants = @project.crews.get_all_plants
      @crews = @project.plants.reject { |plant| plant = @crew_plants.pluck(:plant_id).include?(plant.id) }
    else
      @crew_employee = @project.crews.get_all_employees
      @crews = @project.employees.reject { |employee| employee = @crew_employee.pluck(:employee_id).include?(employee.id) }
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
        begin
          unless plant_id.empty?
            @project.crews.create(plant_id: plant_id.to_i, foreman_id: params[:foreman_id])
          end
        rescue => e
          e.message
        end
      end
    else
      params[:crew][:employee_ids].each do |employee_id|
        begin
          unless employee_id.empty?
            @project.crews.create(employee_id: employee_id.to_i, foreman_id: params[:foreman_id])
          end
        rescue => e
          e.message
        end
      end
    end

    respond_to do |format|
      format.html { redirect_to project_crews_path, notice: 'Crew was successfully created.' }
      format.json { render :show, status: :created, location: @crew }
    end
  end

  # PATCH/PUT /crews/1
  # PATCH/PUT /crews/1.json
  def update
    respond_to do |format|
      if @crew.update(crew_params)
        format.html { redirect_to @crew, notice: 'Crew was successfully updated.' }
        format.json { render :show, status: :ok, location: @crew }
      else
        format.html { render :edit }
        format.json { render json: @crew.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /crews/1
  # DELETE /crews/1.json
  def destroy
    @crew = @project.crews.find(params[:id])
    @crew.destroy
    @destroy = true
    respond_to do |format|
      format.js
    end
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def set_crew
    @crew = Crew.find(params[:id])
  end

  def get_project
    @project = Project.find(params[:project_id])
  end

  # Only allow a list of trusted parameters through.
  def crew_params
    params.require(:crew).permit(project_id, employee_id, plant_id, foreman_id)
  end
end
