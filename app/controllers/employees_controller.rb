class EmployeesController < ApplicationController
  include EmployeesHelper
  before_action :set_employee, only: [:show, :edit, :update, :destroy]
  before_action :get_project, only: [:new, :show, :edit, :update, :create, :index, :import, :destroy]
  load_and_authorize_resource
  # GET /employees
  # GET /employees.json
  def index
    @employees = @project.employees
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
  end

  # GET /employees/new
  def new
    @employee = Employee.new
  end

  # GET /employees/1/edit
  def edit
  end

  # POST /employees
  # POST /employees.json
  def create

    @employee = @project.employees.new(employee_params)
    if ((@project.start_date..@project.end_date).cover?(@employee.contract_start_date)) &&
        (@project.start_date..@project.end_date).cover?(@employee.contract_end_date)
      @employee.client_company_id = @project.client_company_id
      @employee.country_name = @project.client_company.country_name
      @employee.foreman_start_date = @employee.contract_start_date

      respond_to do |format|
        if @employee.save
          @employee.project_company.update(number_of_employee: @employee.project_company.number_of_employee + 1) rescue nil
          format.html { redirect_to "/projects/#{@project.id}/employees", notice: 'Employee was successfully created.' }
          format.json { render :show, status: :created, location: @employee }
        else
          format.html { render :new }
          format.json { render json: @employee.errors, status: :unprocessable_entity }
        end
      end
    else
      @employee.errors.add(:base, 'Date should be sub set of project start and end date.')
      render :action => 'new'
    end
  end

  # PATCH/PUT /employees/1
  # PATCH/PUT /employees/1.json
  def update
    # if ((@project.start_date..@project.end_date).cover?(params[:employee][:foreman_start_date]))
      respond_to do |format|
        if @employee.update(employee_params)
          format.html { redirect_to "/projects/#{@project.id}/employees", notice: 'Employee was successfully updated.' }
          format.json { render :show, status: :ok, location: @employee }
        else
          format.html { render :edit }
          format.json { render json: @employee.errors, status: :unprocessable_entity }
        end
      end
    # else
    #   @employee.errors.add(:base, 'Date should be sub set of project start and end date.')
    #   render :action => 'edit'
    # end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    begin
      if @employee.other_manager.present? || @employee.budget_holders.present? || @employee.foreman.present? ||
          Foreman.find_by_employee_id(@employee.id) || BudgetHolder.find_by_employee_id(@employee.id) ||
          OtherManager.find_by_employee_id(@employee.id) || @employee.employee_time_sheets.present?
        respond_to do |format|
          format.js
        end
      else
        @employee.project_company.update(number_of_employee: @employee.project_company.number_of_employee - 1)
        @employee.destroy
        @destroy = true
        respond_to do |format|
          format.js
        end
      end
    rescue => e
      redirect_to project_employees_path, notice: e.message
    end
  end

  def import
    errors = Employee.import_file(params[:file], current_user, @project)
    if errors == nil
      flash[:notice] = 'File Imported Successfully'
    else
      flash[:notice] = errors
    end
    redirect_to project_employees_path
  end

  def download_template
    send_file(
        "#{Rails.root}/public/documents/etemplate.csv",
        filename: "etemplate.csv",
    )
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_employee
    @employee = Employee.find_by_id(params[:id])
  end

  def get_project
    @project = Project.find(params[:project_id])
  end

  # Only allow a list of trusted parameters through.
  def employee_params
    employe_params = params.require(:employee).permit(:first_name, :last_name,
                                                      :employee_id, :phone, :email, :employee_type_id,
                                                      :gender, :home_company_role, :employee_name,
                                                      :contract_start_date, :contract_end_date, :phone_country_code,
                                                      :status, :project_company_id, :project_id,
                                                      :other_manager_id, :foreman_id, :project_role,
                                                      :employee_type_id, :country_name, :client_company_id,
                                                      :foreman_start_date)
    employe_params[:gender] = params[:employee][:gender].to_i if params[:employee][:gender].present?
    employe_params[:status] = params[:employee][:status].to_i
    return employe_params
  end

end
