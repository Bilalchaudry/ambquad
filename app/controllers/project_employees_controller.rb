class ProjectEmployeesController < ApplicationController
  before_action :get_project, only: [:new, :show, :edit, :update, :create, :index, :destroy]
  before_action :set_project_employee, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /project_employees
  # GET /project_employees.json
  def index
    @project_employees = @project.project_employees
  end

  # GET /project_employees/1
  # GET /project_employees/1.json
  def show
  end

  # GET /project_employees/new
  def new
    @project_employee = ProjectEmployee.new
  end

  # GET /project_employees/1/edit
  def edit
  end

  # POST /project_employees
  # POST /project_employees.json
  def create
    # @project_employee = @project.project_employees.new(project_employee_params)
    # @project_employee.project_id = params[:project_id]
    params[:project_employee][:employee_ids].each do |employee_id|
      begin
        project_employee = ProjectEmployee.create(project_id: @project.id, total_hours: params[:project_employee][:total_hours],
                               contract_start_date: params[:project_employee][:contract_start_date],
                               contract_end_date: params[:project_employee][:contract_end_date],
                               employee_type_id: params[:project_employee][:employee_type_id],
                               foreman_id: params[:project_employee][:foreman_id], other_manager_id: params[:project_employee][:other_manager_id],
                               project_company_id: params[:project_employee][:project_company_id],
                               employee_id: employee_id.to_i)
        ProjectProjectEmployee.create(project_id: @project.id, project_employee_id: project_employee.id)

      rescue => e
      end
    end
    redirect_to project_project_employees_path(@project), notice: 'Project employee was successfully created.'
  end

  # PATCH/PUT /project_employees/1
  # PATCH/PUT /project_employees/1.json
  def update
    respond_to do |format|
      if @project_employee.update(project_employee_params)
        format.html {redirect_to project_project_employees_path, notice: 'Project employee was successfully updated.'}
        format.json {render :show, status: :ok, location: @project_employee}
      else
        format.html {render :edit}
        format.json {render json: @project_employee.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /project_employees/1
  # DELETE /project_employees/1.json
  def destroy
    @project_employee.destroy
    respond_to do |format|
      format.html {redirect_to project_project_employees_path, notice: 'Project employee was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project_employee
    @project_employee = ProjectEmployee.find(params[:id])
  end

  def get_project
    @project = Project.find(params[:project_id])
  end

  # Only allow a list of trusted parameters through.
  def project_employee_params
    params.require(:project_employee).permit(:total_hours, :contract_start_date, :contract_end_date,
                                             :employee_id, :employee_type_id, :project_id, :foreman_id,
                                             :other_manager_id, :project_company_id)
  end
end
