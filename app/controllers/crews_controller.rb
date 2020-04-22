class CrewsController < ApplicationController
  # before_action :set_crew, only: [:show, :edit, :update, :destroy]
  before_action :get_project, only: [:new, :show, :edit, :update, :create, :index, :plants_list, :employees_list]


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
      @crew_plants = @project.crews.where.not(plant_id: nil)
      @plants = @project.plants
      @plants.each do |plant|
        search_data = @crew_plants.where(plant_id: plant.id, foreman_id: params[:id])
        if search_data.empty?
          @crews.push(plant)
        end
      end
    else
      @crew_employee = @project.crews.where.not(employee_id: nil)
      @employee = @project.employees
      @employee.each do |employee|
        search_data = @crew_employee.where(employee_id: employee.id, foreman_id: params[:id])
        if search_data.empty?
          @crews.push(employee)
        end
      end
    end
    @crew = Crew.new
  end

  # GET /crews/1/edit
  def edit
  end

  # POST /crews
  # POST /crews.json
  def create
    @crew=[]
    if params[:plant].present?
      params[:crew][:plant_ids].each do |plant_id|
        begin
          unless plant_id.empty?
            Crew.create(project_id: @project.id, plant_id: plant_id.to_i, foreman_id: params[:foreman_id])
          end
        rescue => e
          puts e.inspect
        end
      end
    else
      params[:crew][:employee_ids].each do |employee_id|
        begin
          unless employee_id.empty?
            Crew.create(project_id: @project.id, employee_id: employee_id.to_i, foreman_id: params[:foreman_id])
          end
        rescue => e
          puts e.inspect
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
    @crew.destroy
    respond_to do |format|
      format.html { redirect_to crews_url, notice: 'Crew was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def plants_list
    @all_plants = @project.crews.where.not(plant_id: nil)
    @plants = @all_plants.where(foreman_id: params[:id], project_id: @project.id).to_a
  end

  def employees_list
    @all_plants = @project.crews.where.not(employee_id: nil)
    @employees = @all_plants.where(foreman_id: params[:id], project_id: @project.id).to_a
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
