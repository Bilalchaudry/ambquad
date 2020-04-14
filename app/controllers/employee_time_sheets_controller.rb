class EmployeeTimeSheetsController < ApplicationController
  before_action :get_project, only: :index
  before_action :set_employee_time_sheet, only: [:show, :edit, :update, :destroy]

  # GET /employee_time_sheets
  # GET /employee_time_sheets.json
  def index
    if params[:find_emp_codes].present?
    employee_used_time_sheet_code = @project.time_sheet_cost_codes.where(employee_time_sheet_id: params[:time_sheet_employee_id], employee_id: params[:emp_id], created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).pluck(:cost_code_id)
    @employee_time_sheets = @project.employee_time_sheets.where(employee_create_date: Time.now.strftime("%Y-%m-%d")).order(:id)
    unused_codes_for_employee = @project.cost_codes.where.not(id: employee_used_time_sheet_code)
    render json: unused_codes_for_employee

    elsif params[:find_plant_codes].present?
                                  # Project.first.time_sheet_cost_codes.where(time_sheet_plant_id: 49, plant_id: 1, created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).pluck(:cost_code_id)

      plant_used_time_sheet_code = @project.time_sheet_cost_codes.where(plant_id: params[:plant_id], time_sheet_plant_id: params[:time_sheet_plant_id], created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).pluck(:cost_code_id)
      @plant_time_sheets = @project.plant_time_sheets.where(employee_create_date: Time.now.strftime("%Y-%m-%d")).order(:id)
      unused_codes_for_plant = @project.cost_codes.where.not(id: plant_used_time_sheet_code)
      render json: unused_codes_for_plant

    elsif params[:date].present? && params[:search_date].present?
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
      @employee_time_sheets_previous_data = @project.employee_time_sheets.where(employee_create_date: params[:date])
      unless @employee_time_sheets_previous_data.empty?
        @employee_time_sheets_copy_data = []
      @employee_time_sheets_previous_data.each do |project_employee|
        @employee_time_sheets_copy_data << @project.employee_time_sheets.new(employee: project_employee.employee, labour_type: project_employee.labour_type,
                                                                             project_company_id: project_employee.project_company_id, manager: project_employee.manager,
                                                                             foreman_name: project_employee.foreman_name, total_hours: project_employee.total_hours,
                                                                             employee_type_id: project_employee.employee_type_id, employee_id: project_employee.employee_id,
                                                                             employee_create_date: Time.now.strftime("%Y-%m-%d"), project_id: @project.id)
      end
        EmployeeTimeSheet.import @employee_time_sheets_copy_data

        i=0
        for single_employee in @employee_time_sheets_previous_data
          @new_cost_codes = []
          @old_cost_code = TimeSheetCostCode.where(time_sheet_employee_id: single_employee.id)
          @old_cost_code.each do |cost_code|
            @new_cost_codes = @project.time_sheet_cost_codes.create(cost_code_id: cost_code.cost_code_id, cost_code: cost_code.cost_code,
                                                                    employee_id: cost_code.employee_id, hrs: cost_code.hrs,
                                                                    time_sheet_employee_id: @employee_time_sheets_copy_data[i].id, employee_time_sheet_id: @employee_time_sheets_copy_data[i].id)
          end
          i=i+1
        end
      end

      @employee_time_sheets = @project.employee_time_sheets.where(employee_create_date: Time.now.strftime("%Y-%m-%d")).order(:id)
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
        devided_time = (params[:total_hour].to_f / @time_sheet_cost_code.count.to_f).round(2)
        @time_sheet_cost_code.update(hrs: devided_time)
      end
      @employee_time_sheets = @project.employee_time_sheets.where(employee_create_date: @employee_time_sheet_data.employee_create_date).order(:id)
      respond_to do |f|
        f.js
        f.html
      end
    else
      @employee_time_sheets = @project.employee_time_sheets.where(employee_create_date: Time.now.strftime("%Y-%m-%d")).order(:id)
    end
  end

  # GET /employee_time_sheets/1
  # GET /employee_time_sheets/1.json
  def show
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
