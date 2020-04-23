class EmployeesController < ApplicationController
  include EmployeesHelper
  before_action :set_employee, only: [:show, :edit, :update, :destroy]
  before_action :get_project, only: [:new, :show, :edit, :update, :create, :index, :import]
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
    @employee.client_company_id = @project.client_company_id
    @employee.country_name = @project.client_company.country_name
    # @employee.country_code = ISO3166::Country.find_country_by_name(@employee.country_name).country_code rescue nil

    respond_to do |format|
      if @employee.save
        @employee_time_sheet = EmployeeTimeSheet.new(employee: @employee.employee_name, labour_type: @employee.employee_type.employee_type, employee_id: @employee.id,
                                                     project_company_id: @employee.project_company_id, total_hours: 0, employee_type_id: @employee.employee_type_id,
                                                     project_id: @project.id, employee_create_date: Time.now.strftime("%Y-%m-%d"), foreman_id: @employee.foreman_id)
        @employee_time_sheet.manager = @employee.other_manager.employee.employee_name rescue nil
        @employee_time_sheet.foreman_name = @employee.foreman.employee.employee_name rescue nil
        if @employee_time_sheet.save
          format.html { redirect_to "/projects/#{@project.id}/employees", notice: 'Employee was successfully created.' }
          format.json { render :show, status: :created, location: @employee }
        else
          format.html { render :new }
          format.json { render json: @employee.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /employees/1
  # PATCH/PUT /employees/1.json
  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html {redirect_to "/projects/#{@project.id}/employees", notice: 'Employee was successfully updated.'}
        format.json {render :show, status: :ok, location: @employee}
      else
        format.html {render :edit}
        format.json {render json: @employee.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    begin
      if @employee.project_employees.present? || @employee.other_managers.present? || @employee.budget_holders.present?
        respond_to do |format|
          format.js
        end
      else
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
    file = params[:file]
    # File.open(Rails.root.join('public', 'documents', file.original_filename), 'wb') do |f|
    #   f.write(file.read)
    # end
    user = current_user
    errors = Employee.import_file(params[:file], user, @project)
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
                                                      :employee_type_id, :country_name, :client_company_id)
    employe_params[:gender] = params[:employee][:gender].to_i
    employe_params[:status] = params[:employee][:status].to_i
    return employe_params
  end
end
