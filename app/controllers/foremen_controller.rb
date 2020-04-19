class ForemenController < ApplicationController
  include ForemenHelper
  before_action :set_foreman, only: [:show, :edit, :update, :destroy]
  before_action :get_project, only: [:new, :show, :edit, :update, :create, :index,
                                     :crew, :destroy, :project_foreman_list, :import]

  load_and_authorize_resource

  # GET /foremen
  # GET /foremen.json
  def index
    @foremens = @project.foremen
  end

  def crew
    @foremens = @project.foremen
  end

  def project_foreman_list
    @project_employees = @project.project_employees.where(foreman_id: params[:foreman])
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
    params[:foreman][:employee_ids].each do |employee_id|
      begin
        Foreman.create(project_id: @project.id, employee_id: employee_id.to_i,
                       client_company_id: @project.client_company_id)
      rescue => e
        puts e.inspect
      end
    end
    redirect_to project_foremen_path(@project), notice: 'Foreman was successfully created.'
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
    begin
      if @foreman.nil?
        respond_to do |format|
          format.js
        end
      else
        @foreman.destroy
        @destroy = true
        respond_to do |format|
          format.js
        end
      end
    rescue => e
      redirect_to "/projects/#{@project.id}/foremen", notice: 'Foreman can not deleted because it is linked with its assosiative records'
    end
  end

  def import
    file = params[:file]
    File.open(Rails.root.join('public', 'documents', file.original_filename), 'wb') do |f|
      f.write(file.read)
    end
    errors = Foreman.import_file(params[:file], current_user, @project)
    if errors == nil
      flash[:notice] = 'File Imported Successfully'
    else
      flash[:notice] = errors
    end
    redirect_to project_foremen_path
  end

  def download_template
    send_file(
        "#{Rails.root}/public/documents/foremen.csv",
        filename: "foremen.csv",
        )
  end

  # def users_except_foremen
  #   @users_for_foreman = Employee.all.order( 'id ASC' ) - @foremen
  # end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_foreman
    @foreman = Foreman.find(params[:id])
  end

  def get_project
    @project = Project.find(params[:project_id])
  end

  # Only allow a list of trusted parameters through.
  def foreman_params
    params.require(:foreman).permit(:employee_id)
  end
end
