class ForemenController < ApplicationController
  include ForemenHelper
  before_action :get_project, only: [:new, :show, :edit, :update, :create, :index, :crew, :destroy]
  before_action :set_foreman, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource

  # GET /foremen
  # GET /foremen.json
  def index
    @foremens = @project.foremen
  end

  def crew
    @foremens = Foreman.where(project_id: @project.id)
  end

  def project_foreman_list
    @foreman_employees = @project.employees.where(foreman_id: params[:project_id])
  end

  # GET /foremen/1
  # GET /foremen/1.json
  def show
  end

  # GET /foremen/new
  def new
    @foreman = Foreman.new
  end

  # GET /foremen/1/edit
  def edit
  end

  # POST /foremen
  # POST /foremen.json
  def create
    @foreman = @project.foremen.new(foreman_params)
    respond_to do |format|
      if @foreman.save
        format.html {redirect_to project_foremen_path(@project), notice: 'Foreman was successfully created.'}
        format.json {render :show, status: :created, location: @foreman}
      else
        format.html {render :new}
        format.json {render json: @foreman.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /foremen/1
  # PATCH/PUT /foremen/1.json
  def update
    respond_to do |format|
      if @foreman.update(foreman_params)
        format.html {redirect_to project_foremen_path(@project), notice: 'Foreman was successfully updated.'}
        format.json {render :show, status: :ok, location: @foreman}
      else
        format.html {render :edit}
        format.json {render json: @foreman.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /foremen/1
  # DELETE /foremen/1.json
  def destroy
    @foreman.destroy
    respond_to do |format|
      format.html {redirect_to project_foremen_path(@project), notice: 'Foreman was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  # def users_except_foremen
  #   @users_for_foreman = Employee.all.order( 'id ASC' ) - @foremen
  # end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_foreman
    @foreman = @project.foremen.find(params[:id])
  end

  def get_project
    @project = Project.find(params[:project_id])
  end

  # Only allow a list of trusted parameters through.
  def foreman_params
    params.require(:foreman).permit(:employee_id)
  end
end
