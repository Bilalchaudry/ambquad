class PlantsController < ApplicationController
  before_action :set_plant, only: [:show, :edit, :update, :destroy]
  before_action :get_project, only: [:new, :show, :edit, :update, :create, :index, :import, :destroy]
  load_and_authorize_resource

  # GET /plants
  # GET /plants.json
  def index
    @plants = @project.plants
  end

  # GET /plants/1
  # GET /plants/1.json
  def show
  end

  # GET /plants/new
  def new
    @plant = Plant.new
  end

  # GET /plants/1/edit
  def edit
  end

  # POST /plants
  # POST /plants.json
  def create
    @plant = @project.plants.new(plant_params)
    @plant.foreman_start_date = @plant.contract_start_date
    @plant.foreman_end_date = @plant.contract_end_date
    @plant.client_company_id = @project.client_company_id
    if ((@project.start_date..@project.end_date).cover?(@plant.contract_start_date)) &&
        ((@project.start_date..@project.end_date).cover?(@plant.contract_end_date))

      respond_to do |format|
        if @plant.save
          format.html {redirect_to project_plants_path, notice: 'Plant was successfully created.'}
          format.json {render :show, status: :created, location: @plant}
        else
          format.html {render :new}
          format.json {render json: @plant.errors, status: :unprocessable_entity}
        end


      end
    else
      @plant.errors.add(:base, 'Date should be sub set of project start and end date.')
      render :action => 'new'
    end
  end

  # PATCH/PUT /plants/1
  # PATCH/PUT /plants/1.json
  def update
    # if ((@plant.start_date..@project.end_date).cover?(params[:plant][:foreman_start_date]))
    respond_to do |format|
      # if @plant.foreman_id.eql?(params[:plant][:foreman_id])
      if @plant.update(plant_params)

        format.html {redirect_to "/projects/#{@project.id}/plants", notice: 'Plant was successfully updated.'}
        format.json {render :show, status: :ok, location: @plant}
      else
        format.html {render :edit}
        format.json {render json: @plant.errors, status: :unprocessable_entity}
      end

    end

  end

  # DELETE /plants/1
  # DELETE /plants/1.json
  def destroy
    begin
      if @plant.nil? || @plant.plant_time_sheets.present?.present? || @plant.foreman.present?
        respond_to do |format|
          format.js
        end
      else
        @plant.destroy
        @destroy = true
        respond_to do |format|
          format.js
        end
      end
    rescue => e
      redirect_to "/projects/#{@project.id}/plants", notice: e.message
    end
  end

  def import
    file = params[:file]

    errors = Plant.import_file(params[:file], @project)
    if errors == nil
      flash[:notice] = 'File Imported Successfully'
    else
      flash[:notice] = errors
    end
    redirect_to project_plants_path
  end

  def download_template
    send_file(
        "#{Rails.root}/public/documents/plant_template.csv",
        filename: "plant_template.csv",
    )
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_plant
    @plant = Plant.find(params[:id])
  end

  def get_project
    @project = Project.find(params[:project_id])
  end

  # Only allow a list of trusted parameters through.
  def plant_params
    pp = params.require(:plant).permit(:plant_name, :plant_id, :plant_type_id, :project_company_id,
                                       :contract_start_date, :contract_end_date, :market_value,
                                       :offload, :foreman_id, :other_manager_id, :status, :foreman_start_date)
    pp[:status] = params[:plant][:status].to_i

    return pp
  end
end
