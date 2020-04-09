class PlantTimeSheetsController < ApplicationController
  before_action :get_project, only: :index
  before_action :set_plant_time_sheet, only: [:show, :edit, :update, :destroy]

  # GET /plant_time_sheets
  # GET /plant_time_sheets.json
  def index
    if params[:date].present? && params[:search_date].present?
      @plant_time_sheets = @project.plant_time_sheets.where(plant_create_date: params[:date])
      if @plant_time_sheets.empty?
        @project_plant = @project.project_plants
        @plant_time_sheets = []
        @project_plant.each do |project_plant|

          plant_name = Plant.find(project_plant.plant_id.to_i).plant_name
          manager_first_name = OtherManager.find(project_plant.other_manager_id).employee.first_name
          manager_last_name = OtherManager.find(project_plant.other_manager_id).employee.last_name
          @plant_time_sheets << @project.plant_time_sheets.new(plant_id: project_plant.plant_id, plant_name:  plant_name, project_company_id: project_plant.project_company_id,
                                foreman_id: project_plant.foreman_id,project_id: project_plant.project_id, plant_create_date: params[:date],
                                manager: manager_first_name + ' ' + manager_last_name, total_hours: 0 )
          
        end
        PlantTimeSheet.import @plant_time_sheets
      end
      respond_to do |f|
        f.js
        f.html
      end
    elsif params[:date].present? && params[:copy_from_previous].present?
      @plant_time_sheets = @project.plant_time_sheets

      respond_to do |f|
        f.js
        f.html
      end
    elsif params[:total_hour].present? && params[:update_total_hour].present? && params[:data_id]
      @plant_time_sheets = @project.plant_time_sheets.where(id: params[:data_id])
      @plant_time_sheets.update(total_hours: params[:total_hour])
      @plant_time_sheets = @project.plant_time_sheets.order :id
      respond_to do |f|
        f.js
        f.html
      end
    else
      @plant_time_sheets = @project.plant_time_sheets.order :id
    end
  end

  # GET /plant_time_sheets/1
  # GET /plant_time_sheets/1.json
  def show
  end

  # GET /plant_time_sheets/new
  def new
    @plant_time_sheet = PlantTimeSheet.new
  end

  # GET /plant_time_sheets/1/edit
  def edit
  end

  # POST /plant_time_sheets
  # POST /plant_time_sheets.json
  def create
    @plant_time_sheet = PlantTimeSheet.new(plant_time_sheet_params)

    respond_to do |format|
      if @plant_time_sheet.save
        format.html { redirect_to @plant_time_sheet, notice: 'Plant time sheet was successfully created.' }
        format.json { render :show, status: :created, location: @plant_time_sheet }
      else
        format.html { render :new }
        format.json { render json: @plant_time_sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plant_time_sheets/1
  # PATCH/PUT /plant_time_sheets/1.json
  def update
    respond_to do |format|
      if @plant_time_sheet.update(plant_time_sheet_params)
        format.html { redirect_to @plant_time_sheet, notice: 'Plant time sheet was successfully updated.' }
        format.json { render :show, status: :ok, location: @plant_time_sheet }
      else
        format.html { render :edit }
        format.json { render json: @plant_time_sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plant_time_sheets/1
  # DELETE /plant_time_sheets/1.json
  def destroy
    @plant_time_sheet.destroy
    respond_to do |format|
      format.html { redirect_to plant_time_sheets_url, notice: 'Plant time sheet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def get_project
    @project = Project.find(params[:project_id])
    @cost_codes = @project.cost_codes rescue nil
    used_cost_code = @project.time_sheet_cost_codes.all.pluck(:cost_code_id)
    @project_cost_codes = @cost_codes.where.not(id: used_cost_code) rescue nil
  end
    def set_plant_time_sheet
      @plant_time_sheet = PlantTimeSheet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def plant_time_sheet_params
      params.require(:plant_time_sheet).permit(:plant_id, :plant_name, :plant_id, :company, :project_company_id, :manager, :foreman_id, :total_hours)
    end
end
