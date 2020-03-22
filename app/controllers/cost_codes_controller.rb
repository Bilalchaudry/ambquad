class CostCodesController < ApplicationController
  before_action :set_cost_code, only: [:show, :edit, :update, :destroy]

  # GET /cost_codes
  # GET /cost_codes.json
  def index
    @cost_codes = CostCode.all
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
    @cost_code = CostCode.new(cost_code_params)

    respond_to do |format|
      if @cost_code.save
        format.html { redirect_to @cost_code, notice: 'Cost code was successfully created.' }
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
        format.html { redirect_to @cost_code, notice: 'Cost code was successfully updated.' }
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cost_code
      @cost_code = CostCode.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cost_code_params
      params.require(:cost_code).permit(:cost_code_id, :cost_code_description, :project_id)
    end
end
