class ProjectCompaniesController < ApplicationController
  before_action :set_project_company, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  # GET /project_companies
  # GET /project_companies.json
  def index
    @project_companies = current_user.client_company.project_companies
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
    @project_company = ProjectCompany.new(project_company_params)
    @project_company.client_company_id = current_user.client_company.id

    respond_to do |format|
      if @project_company.save
        @project_company.projects << Project.find_by_id(params[:project_company][:project_id])
        format.html { redirect_to @project_company, notice: 'Project company was successfully created.' }
        format.json { render :show, status: :created, location: @project_company }
      else
        format.html { render :new }
        format.json { render json: @project_company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project_companies/1
  # PATCH/PUT /project_companies/1.json
  def update
    respond_to do |format|
      if @project_company.update(project_company_params)
        format.html { redirect_to @project_company, notice: 'Project company was successfully updated.' }
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
    @project_company.destroy
    respond_to do |format|
      format.html { redirect_to project_companies_url, notice: 'Project company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    file = params[:file]
    File.open(Rails.root.join('public', 'documents', file.original_filename), 'wb') do |f|
      f.write(file.read)
    end
    user = current_user
    ProjectCompany.import(params[:file], user)
    redirect_to project_companies_url, notice: "created"
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

    # Only allow a list of trusted parameters through.
    def project_company_params
      params.require(:project_company).permit(:company_summary, :project_role, :address, :phone, :primary_poc_first_name, :primary_poc_last_name, :poc_email, :poc_phone, :client_company_id, :project_id, :company_name)
    end
end
