class BudgetHoldersController < ApplicationController
  before_action :get_project, only: [:new, :show, :edit, :update, :create, :index, :destroy, :import]
  before_action :set_budget_holder, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /budget_holders
  # GET /budget_holders.json
  def index
    @budget_holders = @project.budget_holders
  end

  # GET /budget_holders/1
  # GET /budget_holders/1.json
  def show
  end

  # GET /budget_holders/new
  def new
    @budget_holder = BudgetHolder.new
  end

  # GET /budget_holders/1/edit
  def edit
  end

  # POST /budget_holders
  # POST /budget_holders.json
  def create
    params[:budget_holder][:employee_ids].each do |employee_id|
      begin
        BudgetHolder.create(project_id: @project.id, employee_id: employee_id.to_i,
                            client_company_id: @project.client_company_id)
      rescue => e
        puts e.inspect
      end
    end
    redirect_to project_budget_holders_path(@project), notice: 'Budget Holder was successfully created.'
  end

  # PATCH/PUT /budget_holders/1
  # PATCH/PUT /budget_holders/1.json
  def update
    respond_to do |format|
      if @budget_holder.update(budget_holder_params)
        format.html {redirect_to "/projects/#{@project.id}/budget_holders", notice: 'Budget holder was successfully updated.'}
        format.json {render :show, status: :ok, location: @budget_holder}
      else
        format.html {render :edit}
        format.json {render json: @budget_holder.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /budget_holders/1
  # DELETE /budget_holders/1.json
  def destroy
    begin
      if @budget_holder.nil?
        respond_to do |format|
          format.js
        end
      else
        @budget_holder.destroy
        @destroy = true
        respond_to do |format|
          format.js
        end
      end
    rescue => e
      redirect_to "/projects/#{@project.id}/budget_holders", notice: 'Budget Holder can not deleted because it is linked with its assosiative records'
    end
  end

  def import
    file = params[:file]

    File.open(Rails.root.join('public', 'documents', file.original_filename), 'wb') do |f|
      f.write(file.read)
    end

    errors = BudgetHolder.import_file(params[:file], current_user, @project)
    if errors == nil
      flash[:notice] = 'File Imported Successfully'
    else
      flash[:notice] = errors
    end
    redirect_to project_budget_holders_path
  end

  def download_template
    send_file(
        "#{Rails.root}/public/documents/budget_holders.csv",
        filename: "budget_holders.csv",
        )
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_budget_holder
    @budget_holder = BudgetHolder.find(params[:id])
  end

  def get_project
    @project = Project.find(params[:project_id])
  end

  # Only allow a list of trusted parameters through.
  def budget_holder_params
    params.require(:budget_holder).permit(:employee_id, :client_company_id)
  end
end
