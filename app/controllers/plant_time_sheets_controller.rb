class PlantTimeSheetsController < ApplicationController
  before_action :get_project, only: :index
  before_action :set_plant_time_sheet, only: [:show, :edit, :update, :destroy]

  # GET /plant_time_sheets
  # GET /plant_time_sheets.json
  def index
    @plant_time_sheets = PlantTimeSheet.all
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
