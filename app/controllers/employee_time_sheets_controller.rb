class EmployeeTimeSheetsController < ApplicationController
  before_action :get_project, only: :index
  before_action :set_employee_time_sheet, only: [:show, :edit, :update, :destroy]

  # GET /employee_time_sheets
  # GET /employee_time_sheets.json
  def index
    if params[:date].present? && params[:search_date].present?
      @employee_time_sheets = @project.employee_time_sheets.where(employee_create_date: params[:date])
      if @employee_time_sheets.empty?
        @project_employees = @project.project_employees
        @employee_time_sheets = []
        @project_employees.each do |project_employee|
          @employee_time_sheets << @project.employee_time_sheets.new(employee: project_employee.employee.first_name + ' ' + project_employee.employee.last_name,
                                                                           labour_type: project_employee.employee_type.employee_type, project_company_id: project_employee.project_company_id,
                                                                           manager: project_employee.other_manager.employee.first_name, foreman_name: project_employee.foreman.employee.first_name,
                                                                           total_hours: 0, employee_type_id: project_employee.employee_type_id,
                                                                           employee_create_date: params[:date], project_id: @project.id)
        end
        EmployeeTimeSheet.import @employee_time_sheets
      end
      respond_to do |f|
        f.js
        f.html
      end
    elsif params[:date].present? && params[:copy_from_previous].present?
      @employee_time_sheets = @project.employee_time_sheets

      respond_to do |f|
        f.js
        f.html
      end
    elsif params[:total_hour].present? && params[:update_total_hour].present? && params[:data_id]
      @employee_time_sheet_data = @project.employee_time_sheets.where(id: params[:data_id]).first
      @employee_time_sheet_data.update(total_hours: params[:total_hour])
      @time_sheet_cost_code = TimeSheetCostCode.where(employee_id: @employee_time_sheet_data.employee_id, project_id: @employee_time_sheet_data.project_id,
                                                      time_sheet_employee_id: @employee_time_sheet_data.id)
      unless @time_sheet_cost_code.empty?
        devided_time = params[:total_hour].to_f / @time_sheet_cost_code.count.to_f
        @time_sheet_cost_code.update(hrs: devided_time)
      end
      @employee_time_sheets = @project.employee_time_sheets.order(:id)
      respond_to do |f|
        f.js
        f.html
      end
    else
      @employee_time_sheets = @project.employee_time_sheets.order(:id)
    end
  end

  # GET /employee_time_sheets/1
  # GET /employee_time_sheets/1.json
  def show
    # if params[:time_sheet_employee_id].present?
    #   @project = Project.find(params[:project_id])
    #   @cost_codes = @project.cost_codes rescue nil
    #   used_cost_code = @project.time_sheet_cost_codes.all.pluck(:cost_code_id)
    #   @project_cost_codes = @cost_codes.where.not(id: used_cost_code) rescue nil
    #
    #   return @project_cost_codes
    #   respond_to do |f|
    #     f.js
    #     f.html
    #   end
    # end
  end

  # GET /employee_time_sheets/new
  def new
    @employee_time_sheet = EmployeeTimeSheet.new
  end

  # GET /employee_time_sheets/1/edit
  def edit
  end

  # POST /employee_time_sheets
  # POST /employee_time_sheets.json
  def create
    @employee_time_sheet = EmployeeTimeSheet.new(employee_time_sheet_params)

    respond_to do |format|
      if @employee_time_sheet.save
        format.html { redirect_to @employee_time_sheet, notice: 'Employee time sheet was successfully created.' }
        format.json { render :show, status: :created, location: @employee_time_sheet }
      else
        format.html { render :new }
        format.json { render json: @employee_time_sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employee_time_sheets/1
  # PATCH/PUT /employee_time_sheets/1.json
  def update
    respond_to do |format|
      if @employee_time_sheet.update(employee_time_sheet_params)
        format.html { redirect_to @employee_time_sheet, notice: 'Employee time sheet was successfully updated.' }
        format.json { render :show, status: :ok, location: @employee_time_sheet }
      else
        format.html { render :edit }
        format.json { render json: @employee_time_sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employee_time_sheets/1
  # DELETE /employee_time_sheets/1.json
  def destroy
    @employee_time_sheet = EmployeeTimeSheet.find(params[:id])
    @employee_time_sheet.destroy
    respond_to do |format|
      format.html { redirect_to employee_time_sheets_url, notice: 'Employee time sheet was successfully destroyed.' }
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

  def set_employee_time_sheet
    if params[:time_sheet_employee_id].present?
      @employee_time_sheet = EmployeeTimeSheet.find(params[:time_sheet_employee_id])
      else
    @employee_time_sheet = EmployeeTimeSheet.find(params[:id])
    end
  end

  # Only allow a list of trusted parameters through.
  def employee_time_sheet_params
    params.require(:employee_time_sheet).permit(:employee, :employee_id, :labour_type, :employee_type_id, :company, :project_company_id, :manager, :foreman_id, :total_hours)
  end
end
