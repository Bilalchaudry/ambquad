class EmployeesController < ApplicationController
  include EmployeesHelper
  before_action :set_employee, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  # GET /employees
  # GET /employees.json
  def index
    @employees = current_user.client_company.nil? ? Employee.all : current_user.client_company.employees
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
    @employee = Employee.new(employee_params)
    @employee.client_company_id = params[:employee][:client_company_id].present? ?  params[:employee][:client_company_id] : current_user.client_company_id rescue nil
    code = ISO3166::Country.find_country_by_name(@employee.country_name).country_code rescue nil
    @employee.phone = '+' + code + @employee.phone rescue nil

    respond_to do |format|
      if @employee.save
        format.html {redirect_to employees_path, notice: 'Employee was successfully created.'}
        format.json {render :show, status: :created, location: @employee}
      else
        format.html {render :new}
        format.json {render json: @employee.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /employees/1
  # PATCH/PUT /employees/1.json
  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html {redirect_to @employee, notice: 'Employee was successfully updated.'}
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
    @employee.destroy
    respond_to do |format|
      format.html {redirect_to employees_url, notice: 'Employee was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  def import
    file = params[:file]
    File.open(Rails.root.join('public', 'documents', file.original_filename), 'wb') do |f|
      f.write(file.read)
    end
    user = current_user
    errors = Employee.import(params[:file], user)
    if errors == false
      flash[:notice] = 'File Format not Supported'
    else
      flash[:notice] = 'File has been imported successfully.'
    end
    redirect_to employees_url
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

  # Only allow a list of trusted parameters through.
  def employee_params
    employe_params = params.require(:employee).permit(:first_name, :last_name,
                                                      :employee_id, :phone, :email,
                                                      :gender, :home_company_role,
                                                      :contract_start_date, :contract_end_date,
                                                      :status, :project_company_id, :project_id,
                                                      :other_manager_id, :foreman_id,
                                                      :employee_type_id, :country_name, :client_company_id)
    employe_params[:gender] = params[:employee][:gender].to_i
    employe_params[:status] = params[:employee][:status].to_i
    return employe_params
  end
end
