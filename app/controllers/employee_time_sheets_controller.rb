class EmployeeTimeSheetsController < ApplicationController
  before_action :set_employee_time_sheet, only: [:show, :edit, :update, :destroy]

  # GET /employee_time_sheets
  # GET /employee_time_sheets.json
  def index
    if params[:date].present? && params[:search_date].present?
      @employee_time_sheets = EmployeeTimeSheet.where(employee_create_date: params[:date])
      respond_to do |f|
        f.js
        f.html
      end
    else
      @employee_time_sheets = EmployeeTimeSheet.all
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
    # Use callbacks to share common setup or constraints between actions.
    def set_employee_time_sheet
      @employee_time_sheet = EmployeeTimeSheet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def employee_time_sheet_params
      params.require(:employee_time_sheet).permit(:employee, :employee_id, :labour_type, :employee_type_id, :company, :project_company_id, :manager, :foreman_id, :total_hours)
    end
end
