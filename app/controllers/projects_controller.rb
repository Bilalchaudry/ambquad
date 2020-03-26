class ProjectsController < ApplicationController
  load_and_authorize_resource
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :check_company , only: :destroy

  # GET /projects
  # GET /projects.json
  def index
    if current_user.role.eql?("Admin")
      @projects = Project.all
    else
      @projects = current_user.client_company.projects rescue []
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    if params[:delete].present?
      @project.destroy
      redirect_to projects_path
    end
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
    project_company_id = @project.client_company_id
    @project_company = ClientCompany.find(project_company_id) rescue nil
    @client_companies = ClientCompany.all.where.not(id: project_company_id) rescue nil

    project_employee_id = @project.employee_id
    @project_employee = Employee.find(project_employee_id) rescue nil
    @employees = Employee.all.where.not(id: project_employee_id) rescue nil
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    respond_to do |format|
      if params[:project][:client_company_id].present?
        if @project.save
          format.html {redirect_to projects_path, notice: 'Project is successfully created.'}
          format.json {render :show, status: :created, location: @project}
        else
          format.html {render :new}
          format.json {render json: @project.errors, status: :unprocessable_entity}
        end
      else
        format.html {render :new, alert: "Company is required"}
        format.json {render json: @project.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html {redirect_to @project, notice: 'Project was successfully updated.'}
        format.json {render :show, status: :ok, location: @project}
      else
        format.html {render :edit}
        format.json {render json: @project.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html {redirect_to projects_url, notice: 'Project was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  def check_company
    if @project.client_company_id.present?
      redirect_to projects_url, :notice => "Project is linked."
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def project_params
    params.require(:project).permit(:project_name, :site_office_address, :client_company_id, :employee_id )
  end
end
