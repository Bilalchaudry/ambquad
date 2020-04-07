class EmployeeTimeSheetsController < ApplicationController
  before_action :set_employee_time_sheet, only: [:show, :edit, :update, :destroy]
  before_action :get_project, only: [:index]


  # GET /employee_time_sheets
  # GET /employee_time_sheets.json
  def index
    if params[:date].present? && params[:search_date].present?
      @employee_time_sheets = @project.employee_time_sheets.where(employee_create_date: params[:date])
      if @employee_time_sheets.empty?
        @project_employees = @project.project_employees
        unless @project_employees.empty?
          @employee_time_sheets = []
          @project_employees.each do |project_employee|
            @employee_time_sheet_data = @project.employee_time_sheets.create(employee: project_employee.employee.first_name + ' ' + project_employee.employee.last_name,
                                                                             labour_type: project_employee.employee_type.employee_type, project_company_id: project_employee.project_company_id,
                                                                             manager: project_employee.other_manager.employee.first_name, foreman_name: project_employee.foreman.employee.first_name,
                                                                             total_hours: 0, employee_type_id: project_employee.employee_type_id,
                                                                             employee_create_date: params[:date], project_id: @project.id)
            @employee_time_sheets.push(@employee_time_sheet_data)
          end
        end
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
    else
      @employee_time_sheets = @project.employee_time_sheets
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
    @employee_time_sheet.destroy
    respond_to do |format|
      format.html { redirect_to employee_time_sheets_url, notice: 'Employee time sheet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def get_project
    @project = Project.find(params[:project_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_employee_time_sheet
    @employee_time_sheet = EmployeeTimeSheet.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def employee_time_sheet_params
    params.require(:employee_time_sheet).permit(:employee, :employee_id, :labour_type, :employee_type_id,
                                                :company, :project_company_id, :manager, :foreman_id, :total_hours, :project_id)
  end
end
