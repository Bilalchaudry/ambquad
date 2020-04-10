class ProjectPlantsController < ApplicationController
  before_action :get_project, only: [:new, :show, :edit, :update, :create, :index, :destroy]
  before_action :set_project_plant, only: [:show, :edit, :update, :destroy]

  # GET /project_plants
  # GET /project_plants.json
  def index
    @project_plants = @project.project_plants
  end

  # GET /project_plants/1
  # GET /project_plants/1.json
  def show
  end

  # GET /project_plants/new
  def new
    @project_plant = ProjectPlant.new
  end

  # GET /project_plants/1/edit
  def edit
  end

  # POST /project_plants
  # POST /project_plants.json
  def create
    params[:project_plant][:plant_ids].each do |plant_id|
      begin
        project_plant = ProjectPlant.create(plant_id: plant_id.to_i, project_id: @project.id,
                                            contract_start_date: params[:project_plant][:contract_start_date],
                                            contract_end_date: params[:project_plant][:contract_end_date],
                                            plant_type_id: params[:project_plant][:plant_type_id],
                                            foreman_id: params[:project_plant][:foreman_id],
                                            other_manager_id: params[:project_plant][:other_manager_id],
                                            project_company_id: params[:project_plant][:project_company_id],
                                            foreman_start_date: params[:project_plant][:contract_start_date],
                                            foreman_end_date: params[:project_plant][:contract_end_date])
        if project_plant.save
          plant_name = Plant.find(plant_id.to_i).plant_name
          manager_first_name = OtherManager.find(project_plant.other_manager_id).employee.first_name
          manager_last_name = OtherManager.find(project_plant.other_manager_id).employee.last_name
        PlantTimeSheet.create!(plant_id: project_plant.plant_id, plant_name:  plant_name, project_company_id: project_plant.project_company_id,
                              foreman_id: project_plant.foreman_id,project_id: project_plant.project_id,
                              manager: manager_first_name + ' ' + manager_last_name, total_hours: 0, plant_create_date: Time.now.strftime("%Y-%m-%d"))
        end

      rescue => e
      end
    end
    redirect_to project_project_plants_path(@project), notice: 'Plant was successfully created.'
  end

  # PATCH/PUT /project_plants/1
  # PATCH/PUT /project_plants/1.json
  def update
    respond_to do |format|
      if @project_plant.update(project_plant_params)
        format.html {redirect_to project_project_plant_path, notice: 'Project plant was successfully updated.'}
        format.json {render :show, status: :ok, location: @project_plant}
      else
        format.html {render :edit}
        format.json {render json: @project_plant.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /project_plants/1
  # DELETE /project_plants/1.json
  def destroy
    @project_plant.destroy
    respond_to do |format|
      format.html {redirect_to project_project_plants_path(@project), notice: 'Project plant was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project_plant
    @project_plant = ProjectPlant.find(params[:id])
  end

  def get_project
    @project = Project.find(params[:project_id])
  end

  # Only allow a list of trusted parameters through.
  def project_plant_params
    params.require(:project_plant).permit(:plant_id, :plant_type_id, :project_company_id,
                                          :contract_start_date, :contract_end_date, :foreman_id,
                                          :other_manager_id, :status)
  end
end
