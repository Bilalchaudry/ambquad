class ProjectCompaniesController < ApplicationController
  before_action :get_project, only: [:new, :show, :edit, :update, :create, :index, :destroy, :import]
  before_action :set_project_company, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /project_companies
  # GET /project_companies.json
  def index
    @project_companies = @project.project_companies
  end

  # GET /project_companies/1
  # GET /project_companies/1.json
  def show
  end

  # GET /project_companies/new
  def new
    @project_company = ProjectCompany.new
  end

  # GET /project_companies/1/edit
  def edit
  end

  # POST /project_companies
  # POST /project_companies.json
  def create
    @project_company = @project.project_companies.new(project_company_params)
    @project_company.client_company_id = @project.client_company.id
    @project_company.poc_country = @project.client_company.country_name
    if @project_company.country_name != " "
      respond_to do |format|
        if @project_company.save
          # @project_company.projects << @project
          format.html { redirect_to project_project_companies_path, notice: 'Project company was successfully created.' }
          format.json { render :show, status: :created, location: @project_company }
        else
          format.html { render :new }
          format.json { render json: @project_company.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to new_project_project_company_path, notice: 'Please Provide the Country Name'
    end
  end

  # PATCH/PUT /project_companies/1
  # PATCH/PUT /project_companies/1.json
  def update
    respond_to do |format|
      if @project_company.update(project_company_params)
        format.html { redirect_to project_project_companies_path, notice: 'Project company was successfully updated.' }
        format.json { render :show, status: :ok, location: @project_company }
      else
        format.html { render :edit }
        format.json { render json: @project_company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_companies/1
  # DELETE /project_companies/1.json
  def destroy
    begin
      if @project_company.nil? || @project_company.employees.present? || @project_company.plants.present?
        respond_to do |format|
          format.js
        end
      else
        @project_company.destroy
        @destroy = true
        respond_to do |format|
          format.js
        end
      end
    rescue => e
      redirect_to "/projects/#{@project.id}/project_companies", notice: 'Project company  can not deleted because it is linked with its assosiative records'
    end

  end

  def import
    errors = ProjectCompany.import_file(params[:file], current_user, @project)
    if errors == nil
      flash[:notice] = 'File Imported Successfully'
    else
      flash[:notice] = errors
    end
    redirect_to project_project_companies_path
  end

  def download_template
    send_file(
        "#{Rails.root}/public/documents/project_company_template.csv",
        filename: "project_company_template.csv",
    )
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project_company
    @project_company = ProjectCompany.find(params[:id])
  end

  def get_project
    @project = Project.find(params[:project_id])
  end

  # Only allow a list of trusted parameters through.
  def project_company_params
    params.require(:project_company).permit(:company_summary, :project_role, :address, :phone, :city, :state,
                                            :primary_poc_first_name, :primary_poc_last_name, :poc_email,
                                            :poc_phone, :project_id, :company_name, :country_name, :phone,
                                            :poc_country, :phone_country_code, :poc_phone_country_code)
  end
end
