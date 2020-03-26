class CostCodesController < ApplicationController
  load_and_authorize_resource
  before_action :set_cost_code, only: [:show, :edit, :update, :destroy]
  before_action :get_project, only: [:new, :show, :edit, :update, :create, :index]

  # GET /cost_codes
  # GET /cost_codes.json
  def index
    if current_user.role.eql?("Admin")
      @cost_codes = CostCode.all
    else
      @cost_codes = current_user.client_company.cost_codes rescue []
    end
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
        format.html { redirect_to "/projects/#{@project.id}/cost_codes/#{@cost_code.id}", notice: 'Cost code was successfully created.' }
        format.json { render :show, status: :created, location: @cost_code }
      else
        format.html { render :new }
        format.json { render json: @cost_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cost_codes/1
  # PATCH/PUT /cost_codes/1.json
  def update
    respond_to do |format|
      if @cost_code.update(cost_code_params)
        format.html { redirect_to "/projects/#{@project.id}/cost_codes/#{@cost_code.id}", notice: 'Cost code was successfully updated.' }
        format.json { render :show, status: :ok, location: @cost_code }
      else
        format.html { render :edit }
        format.json { render json: @cost_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cost_codes/1
  # DELETE /cost_codes/1.json
  def destroy
    @cost_code.destroy
    respond_to do |format|
      format.html { redirect_to cost_codes_url, notice: 'Cost code was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    file = params[:file]
    File.open(Rails.root.join('public','documents', file.original_filename), 'wb') do |f|
      f.write(file.read)
    end
    CostCode.import(params[:file])
    redirect_to cost_codes_url, notice: "created"
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
      params.require(:cost_code).permit(:cost_code_id, :cost_code_description)
    end
end
