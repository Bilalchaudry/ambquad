class EmployeeTypesController < ApplicationController
  before_action :set_employee_type, only: [:show, :edit, :update, :destroy]
  before_action :get_project, only: [:new, :show, :edit, :update, :create, :index, :import, :destroy]
  load_and_authorize_resource

  # GET /employee_types
  # GET /employee_types.json
  def index
    @employee_types = @project.employee_types rescue []
  end

  # GET /employee_types/1
  # GET /employee_types/1.json
  def show
  end

  # GET /employee_types/new
  def new
    @employee_type = EmployeeType.new
  end

  # GET /employee_types/1/edit
  def edit
  end

  # POST /employee_types
  # POST /employee_types.json
  def create
    @employee_type = @project.employee_types.new(employee_type_params)
    respond_to do |format|
      if @employee_type.save
        format.html {redirect_to "/projects/#{@project.id}/employee_types", notice: 'Employee type was successfully created.'}
        format.json {render :show, status: :created, location: @employee_type}
      else
        format.html {render :new}
        format.json {render json: @employee_type.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /employee_types/1
  # PATCH/PUT /employee_types/1.json
  def update
    respond_to do |format|
      if @employee_type.update(employee_type_params)
        format.html {redirect_to "/projects/#{@project.id}/employee_types", notice: 'Employee type was successfully updated.'}
        format.json {render :show, status: :ok, location: @employee_type}
      else
        format.html {render :edit}
        format.json {render json: @employee_type.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /employee_types/1
  # DELETE /employee_types/1.json
  def destroy
    begin
      if @employee_type.nil? || Employee.find_by_employee_type_id(@employee_type.id).present?
        respond_to do |format|
          format.js
        end
      else
        if @employee_type.destroy
          @destroy = true
        else
        end
        respond_to do |format|
          format.js
        end
      end
    rescue => e
      redirect_to "/projects/#{@project.id}/employee_types", notice: 'Employee Type can not deleted because it is linked with its assosiative records'
    end

  end

  def import
    file = params[:file]

    errors = EmployeeType.import_file(params[:file], @project)
    if errors == nil
      flash[:notice] = 'File Imported Successfully'
    else
      flash[:notice] = errors
    end
    redirect_to project_employee_types_path
  end

  def download_template
    send_file(
        "#{Rails.root}/public/documents/employee_type_template.csv",
        filename: "employee_type_template.csv",
    )
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_employee_type
    @employee_type = EmployeeType.find(params[:id])
  end

  def get_project
    @project = Project.find(params[:project_id])
  end

  # Only allow a list of trusted parameters through.
  def employee_type_params
    params.require(:employee_type).permit(:employee_type)
  end
end
