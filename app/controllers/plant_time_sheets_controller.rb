class PlantTimeSheetsController < ApplicationController
  before_action :get_project, only: :index
  before_action :set_plant_time_sheet, only: [:show, :edit, :update, :destroy]

  # GET /plant_time_sheets
  # GET /plant_time_sheets.json
  def index
    if params[:date].present? && params[:search_date].present?
      @plant_time_sheets = @project.plant_time_sheets.where(plant_create_date: params[:date])
      if @plant_time_sheets.empty?
        @project_plant = @project.plants
        @plant_time_sheets = []
        @project_plant.each do |project_plant|

          manager_first_name = OtherManager.find(project_plant.other_manager_id).employee.first_name
          manager_last_name = OtherManager.find(project_plant.other_manager_id).employee.last_name
          @plant_time_sheets << @project.plant_time_sheets.new(plant_id: project_plant.plant_id, plant_name: project_plant.plant_name, project_company_id: project_plant.project_company_id,
                                                               foreman_id: project_plant.foreman_id, project_id: project_plant.project_id, plant_create_date: params[:date],
                                                               manager: manager_first_name + ' ' + manager_last_name, total_hours: 0)

        end
        PlantTimeSheet.import @plant_time_sheets
      end
      respond_to do |f|
        f.js
        f.html
      end
    elsif params[:date].present? && params[:copy_from_previous].present?
      @plant_time_sheets_previous_data = @project.plant_time_sheets.where(plant_create_date: params[:date])
      unless @plant_time_sheets_previous_data.empty?
        @plant_time_sheets_copy_data = []
        @plant_time_sheets_previous_data.each do |project_plant|
          exist_data = []
          exist_data = @project.plant_time_sheets.where(plant_id: project_plant.plant_id, plant_create_date: Time.now.strftime("%Y-%m-%d"))
          if exist_data.empty?
            @plant_time_sheets_copy_data << @project.plant_time_sheets.new(plant_id: project_plant.plant_id, plant_name: project_plant.plant_name, project_company_id: project_plant.project_company_id,
                                                                           foreman_id: project_plant.foreman_id, project_id: project_plant.project_id, plant_create_date: Time.now.strftime("%Y-%m-%d"),
                                                                           manager: project_plant.manager, total_hours: project_plant.total_hours)
          end
        end
        unless @plant_time_sheets_copy_data.empty?
          PlantTimeSheet.import @plant_time_sheets_copy_data

          i = 0
          for single_plant in @plant_time_sheets_previous_data
            @new_cost_codes = []
            @old_cost_code = TimeSheetCostCode.where(time_sheet_plant_id: single_plant.id)
            @old_cost_code.each do |cost_code|
              @new_cost_codes = @project.time_sheet_cost_codes.create(cost_code_id: cost_code.cost_code_id, cost_code: cost_code.cost_code,
                                                                      plant_id: cost_code.plant_id, hrs: cost_code.hrs,
                                                                      time_sheet_plant_id: @plant_time_sheets_copy_data[i].id)
            end
            i = i + 1
          end
        end
      end
      @plant_time_sheets = @project.plant_time_sheets.where(plant_create_date: Time.now.strftime("%Y-%m-%d"))
      respond_to do |f|
        f.js
        f.html
      end
    elsif params[:total_hour].present? && params[:update_total_hour].present? && params[:data_id]
      @plant_time_sheets = @project.plant_time_sheets.where(id: params[:data_id]).first
      @plant_time_sheets.update(total_hours: params[:total_hour])
      @time_sheet_cost_code = TimeSheetCostCode.where(time_sheet_plant_id: @plant_time_sheets.id)
      unless @time_sheet_cost_code.empty?
        devided_time = (params[:total_hour].to_f / @time_sheet_cost_code.count.to_f).round(2)
        @time_sheet_cost_code.update(hrs: devided_time)
      end
      @plant_time_sheets = @project.plant_time_sheets.where(plant_create_date: @plant_time_sheets.plant_create_date)
      respond_to do |f|
        f.js
        f.html
      end
    else
      @plant_time_sheets = @project.plant_time_sheets.where(plant_create_date: Time.now.strftime("%Y-%m-%d"))
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
