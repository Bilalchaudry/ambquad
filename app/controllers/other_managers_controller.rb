class OtherManagersController < ApplicationController
  include OtherManagersHelper
  before_action :set_other_manager, only: [:show, :edit, :update, :destroy]
  # before_action :employee_except_manager, only: [:new, :edit]
  before_action :get_project, only: [:new, :show, :edit, :update, :create, :index]

  load_and_authorize_resource

  # GET /other_managers
  # GET /other_managers.json
  def index
    @other_managers = @project.other_managers
  end

  # GET /other_managers/1
  # GET /other_managers/1.json
  def show
    if params[:delete].present?
      @other_managers.destroy
      redirect_to other_managers_path
    end
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
    @other_manager = @project.other_managers.new(other_manager_params)
    @other_manager.client_company_id = current_user.client_company_id

    respond_to do |format|
      if @other_manager.save!
        format.html {redirect_to "/projects/#{@project.id}/other_managers", notice: 'Other manager was successfully created.'}
        format.json {render :show, status: :created, location: @other_manager}
      else
        format.html {render :new}
        format.json {render json: @other_manager.errors, status: :unprocessable_entity}
      end
    end
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
    @other_manager.destroy
    respond_to do |format|
      format.html {redirect_to other_managers_url, notice: 'Other manager was successfully destroyed.'}
      format.json {head :no_content}
    end
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
