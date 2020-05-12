class TimeSheetCostCodesController < ApplicationController
  before_action :get_project, only: [:create, :destroy, :index]
  before_action :set_time_sheet_cost_code, only: [:show, :edit, :update, :destroy]

  # GET /time_sheet_cost_codes
  # GET /time_sheet_cost_codes.json
  def index
    if params[:employee_sheet_clear].present?
      @employee_time_sheets = @project.employee_time_sheets.where(timesheet_created_at: params[:today_date]).order(:id)
      @project.time_sheet_cost_codes.where(employee_time_sheet_id: @employee_time_sheets.pluck(:id)).delete_all rescue nil
      @employee_time_sheets.update_all(total_hours: 0)
      respond_to do |format|
        format.js
      end
    else
      @specific_date_cost_codes_clear = @project.time_sheet_cost_codes.where(cost_code_created_at: params[:today_date].to_date)
      @specific_date_cost_codes_clear.destroy_all
      @plant_time_sheets = @project.plant_time_sheets.where(timesheet_created_at: params[:today_date]).order(:id)
      @plant_time_sheets.update_all(total_hours: 0)
      respond_to do |format|
        format.js
      end
    end
  end

  # GET /time_sheet_cost_codes/1
  # GET /time_sheet_cost_codes/1.json
  def show
  end

  # GET /time_sheet_cost_codes/new
  def new
    @time_sheet_cost_code = TimeSheetCostCode.new
  end

  # GET /time_sheet_cost_codes/1/edit
  def edit
  end

  # POST /time_sheet_cost_codes
  # POST /time_sheet_cost_codes.json
  def create
    if params[:plant_id]
      cost_codee = CostCode.find_by_id(params[:cost_code_id]).cost_code_id
      plant_id = PlantTimeSheet.find_by_id(params[:plant_time_sheet_id]).plant_id rescue nil
      @time_sheet_cost_code = @project.time_sheet_cost_codes.create(cost_code_id: params[:cost_code_id],
                                                                    cost_code: cost_codee,
                                                                    plant_id: plant_id,
                                                                    cost_code_created_at: params[:date],
                                                                    time_sheet_employee_id: params[:time_sheet_employee_id],
                                                                    plant_time_sheet_id: params[:plant_time_sheet_id])
      @cost_code = @project.time_sheet_cost_codes.where(plant_time_sheet_id: params[:plant_time_sheet_id])
      unless @cost_code.empty?
        @total_hours = @project.plant_time_sheets.where(id: params[:plant_time_sheet_id]).first
        devided_time = (@total_hours.total_hours.to_f / @cost_code.count.to_f).round(2)
        @cost_code.update(hrs: devided_time)
      end
      respond_to do |format|
        if @time_sheet_cost_code.save
          @plant_time_sheets = @project.plant_time_sheets.where(timesheet_created_at: @total_hours.timesheet_created_at).order(:id)
          format.js
          format.html
          # format.json { render :show, status: :created, location: @time_sheet_cost_code }
        else
          format.html {render :new}
          format.json {render json: @time_sheet_cost_code.errors, status: :unprocessable_entity}
        end
      end
    elsif params[:hrs].present?
      update_cost_code = TimeSheetCostCode.find(params[:id])
      update_cost_code.update_attributes(hrs: params[:hrs])
      respond_to do |format|
        @employee_time_sheets = @project.employee_time_sheets.where(employee_create_date: params[:today_date]).order(:id)
        format.js
      end
    else
      cost_codee = CostCode.find_by_id(params[:cost_code_id]).cost_code_id
      employee_id = EmployeeTimeSheet.find_by_id(params[:time_sheet_employee_id]).employee_id rescue nil
      @time_sheet_cost_code = @project.time_sheet_cost_codes.create(cost_code_id: params[:cost_code_id],
                                                                    cost_code: cost_codee,
                                                                    employee_id: employee_id,
                                                                    cost_code_created_at: params[:date],
                                                                    time_sheet_employee_id: params[:time_sheet_employee_id],
                                                                    employee_time_sheet_id: params[:time_sheet_employee_id])
      @cost_code = @project.time_sheet_cost_codes.where(time_sheet_employee_id: params[:time_sheet_employee_id])
      unless @cost_code.empty?
        @total_hours = @project.employee_time_sheets.where(id: params[:time_sheet_employee_id]).first
        devided_time = (@total_hours.total_hours.to_f / @cost_code.count.to_f).round(2)
        @cost_code.update(hrs: devided_time)
      end
      respond_to do |format|
        if @time_sheet_cost_code.save
          @employee_time_sheets = @project.employee_time_sheets.where(timesheet_created_at: @total_hours.timesheet_created_at).order(:id)
          format.js
          format.html
          # format.json { render :show, status: :created, location: @time_sheet_cost_code }
        else
          format.html {render :new}
          format.json {render json: @time_sheet_cost_code.errors, status: :unprocessable_entity}
        end
      end
    end
  end

  # PATCH/PUT /time_sheet_cost_codes/1
  # PATCH/PUT /time_sheet_cost_codes/1.json
  def update
    respond_to do |format|
      if @time_sheet_cost_code.update(time_sheet_cost_code_params)
        format.html {redirect_to @time_sheet_cost_code, notice: 'Time sheet cost code was successfully updated.'}
        format.json {render :show, status: :ok, location: @time_sheet_cost_code}
      else
        format.html {render :edit}
        format.json {render json: @time_sheet_cost_code.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /time_sheet_cost_codes/1
  # DELETE /time_sheet_cost_codes/1.json
  def destroy
    time_sheet = @time_sheet_cost_code.employee_time_sheet ? @time_sheet_cost_code.employee_time_sheet : @time_sheet_cost_code.plant_time_sheet
    @time_sheet_cost_code.destroy
    respond_to do |format|

      total_hours = time_sheet.total_hours
      total_cost_codes = time_sheet.time_sheet_cost_codes.count.to_f rescue 0.0
      devided_time = (total_hours / total_cost_codes).round(2)
      time_sheet.time_sheet_cost_codes.update(hrs: devided_time)

      if params[:plant_id].present?
        @plant_time_sheets = @project.plant_time_sheets.where(timesheet_created_at: params[:timesheet_date])
      else
        @employee_time_sheets = @project.employee_time_sheets.where(timesheet_created_at: params[:timesheet_date]).order(:id)
      end

      # @plant_time_sheets = @project.plant_time_sheets.where(plant_create_date: params[:plant_timesheet_date]).order(:id)
      format.js
    end
  end

  private

  def get_project
    @project = Project.find(params[:project_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_time_sheet_cost_code
    @time_sheet_cost_code = TimeSheetCostCode.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def time_sheet_cost_code_params
    params.require(:time_sheet_cost_code).permit(:cost_code, :cost_code_id, :hrs)
  end
end
