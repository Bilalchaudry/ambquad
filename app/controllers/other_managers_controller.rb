class OtherManagersController < ApplicationController
  include OtherManagersHelper
  before_action :set_other_manager, only: [:show, :edit, :update, :destroy]
  # before_action :employee_except_manager, only: [:new, :edit]
  before_action :get_project, only: [:new, :show, :edit, :update, :create, :index, :destroy, :import]

  load_and_authorize_resource

  # GET /other_managers
  # GET /other_managers.json
  def index
    @other_managers = @project.other_managers
  end

  # GET /other_managers/1
  # GET /other_managers/1.json
  def show
  end

  # GET /other_managers/new
  def new
    @other_manager = OtherManager.new
  end

  # GET /other_managers/1/edit
  def edit
  end

  # POST /other_managers
  # POST /other_managers.json
  def create
    params[:other_manager][:employee_ids].each do |employee_id|
      begin
        OtherManager.create(project_id: @project.id, employee_id: employee_id.to_i,
                       client_company_id: @project.client_company_id, manager_type: params[:other_manager][:manager_type])
      rescue => e
        puts e.inspect
      end
    end
    redirect_to project_other_managers_path(@project), notice: 'Other manager was successfully created.'
  end


  # PATCH/PUT /other_managers/1
  # PATCH/PUT /other_managers/1.json
  def update
    respond_to do |format|
      if @other_manager.update(other_manager_params)
        format.html {redirect_to "/projects/#{@project.id}/other_managers", notice: 'Other manager was successfully updated.'}
        format.json {render :show, status: :ok, location: @other_manager}
      else
        format.html {render :edit}
        format.json {render json: @other_manager.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /other_managers/1
  # DELETE /other_managers/1.json
  def destroy
    begin
      if @other_manager.nil? || @other_manager.employee.present?
        respond_to do |format|
          format.js
        end
      else
        @other_manager.destroy
        @destroy = true
        respond_to do |format|
          format.js
        end
      end
    rescue => e
      redirect_to "/projects/#{@project.id}/other_managers", notice: 'Cost Code can not deleted because it is linked with its assosiative records'
    end

  end

  def import
    file = params[:file]
    File.open(Rails.root.join('public', 'documents', file.original_filename), 'wb') do |f|
      f.write(file.read)
    end
    errors = OtherManager.import_file(params[:file], current_user, @project)
    if errors == nil
      flash[:notice] = 'File Imported Successfully'
    else
      flash[:notice] = errors
    end
    redirect_to project_other_managers_path
  end

  def download_template
    send_file(
        "#{Rails.root}/public/documents/other_managers.csv",
        filename: "other_managers.csv",
        )
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def set_other_manager
    @other_manager = OtherManager.find(params[:id])
  end

  def get_project
    @project = Project.find(params[:project_id])
  end

  # Only allow a list of trusted parameters through.
  def other_manager_params
    params.require(:other_manager).permit(:manager_type, :employee_id)
  end
end
