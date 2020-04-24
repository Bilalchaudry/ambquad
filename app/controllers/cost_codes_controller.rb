class CostCodesController < ApplicationController
  load_and_authorize_resource
  before_action :set_cost_code, only: [:show, :edit, :update, :destroy]
  before_action :get_project, only: [:new, :show, :edit, :update, :create, :index, :destroy, :import, :select_cost_codes, :assign_cost_codes]

  # GET /cost_codes
  # GET /cost_codes.json
  def index
    @cost_codes = @project.cost_codes
  end

  # GET /cost_codes/1
  # GET /cost_codes/1.json
  def show
  end

  # GET /cost_codes/new
  def new
    @cost_code = CostCode.new
  end

  # GET /cost_codes/1/edit
  def edit
  end

  # POST /cost_codes
  # POST /cost_codes.json
  def create
    @cost_code = @project.cost_codes.new(cost_code_params)
    @cost_code.client_company_id = current_user.client_company_id
    respond_to do |format|
      if @cost_code.save
        format.html {redirect_to "/projects/#{@project.id}/cost_codes", notice: 'Cost code was successfully created.'}
        format.json {render :show, status: :created, location: @cost_code}
      else
        format.html {render :new}
        format.json {render json: @cost_code.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /cost_codes/1
  # PATCH/PUT /cost_codes/1.json
  def update
    respond_to do |format|
      if @cost_code.update(cost_code_params)
        format.html {redirect_to "/projects/#{@project.id}/cost_codes", notice: 'Cost code was successfully updated.'}
        format.json {render :show, status: :ok, location: @cost_code}
      else
        format.html {render :edit}
        format.json {render json: @cost_code.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /cost_codes/1
  # DELETE /cost_codes/1.json
  def destroy
    begin
      if @cost_code.nil?
        respond_to do |format|
          format.js
        end
      else
        @cost_code.destroy
        @destroy = true
        respond_to do |format|
          format.js
        end
      end
    rescue => e
      redirect_to "/projects/#{@project.id}/cost_codes", notice: 'Cost Code can not deleted because it is linked with its assosiative records'
    end
  end

  def select_cost_codes
    @unassign_cost_codes = @project.cost_codes.where(budget_holder_id: nil)
    @budget_holders = @project.budget_holders
  end

  def assign_cost_codes
    cost_code_ids = params[:cost_code_ids].reject { |e| e.empty? }
    budget_holder_id = params[:cost_code][:budget_holder_id]
    if cost_code_ids.present? && budget_holder_id.present?
      @project.cost_codes.where(id: cost_code_ids).update_all(budget_holder_id: budget_holder_id)
      respond_to do |format|
        format.html { redirect_to project_cost_codes_path, notice: 'Cost Code Successfully Assigned' }
      end
    else
      respond_to do |format|
        format.html { redirect_to select_cost_codes_project_cost_codes_path, notice: 'Parameter Missing' }
      end
    end
  end

  def import
    file = params[:file]
    # File.open(Rails.root.join('public', 'documents', file.original_filename), 'wb') do |f|
    #   f.write(file.read)
    # end
    errors = CostCode.import_file(params[:file], current_user, @project)
    if errors == nil
      flash[:notice] = 'File Imported Successfully'
    else
      flash[:notice] = errors
    end
    redirect_to project_cost_codes_path
  end

  def download_template
    send_file(
        "#{Rails.root}/public/documents/cctemplate.csv",
        filename: "cctemplate.csv",
    )
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cost_code
    @cost_code = CostCode.find(params[:id])
  end

  def get_project
    @project = Project.find(params[:project_id])
  end

  # Only allow a list of trusted parameters through.
  def cost_code_params
    params.require(:cost_code).permit(:cost_code_id, :cost_code_description, :budget_holder_id,
                                      :WBS_01, :WBS_01_Description, :WBS_02, :WBS_02_Description,
                                      :WBS_03, :WBS_03_Description, :WBS_04, :WBS_04_Description,
                                      :WBS_05, :WBS_05_Description)
  end
end
