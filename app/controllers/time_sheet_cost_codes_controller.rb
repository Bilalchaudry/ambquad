class TimeSheetCostCodesController < ApplicationController
  before_action :set_time_sheet_cost_code, only: [:show, :edit, :update, :destroy]

  # GET /time_sheet_cost_codes
  # GET /time_sheet_cost_codes.json
  def index
    @time_sheet_cost_codes = TimeSheetCostCode.all
  end

  # GET /time_sheet_cost_codes/1
  # GET /time_sheet_cost_codes/1.json
  def show
  end

  # GET /time_sheet_cost_codes/new
  def new
    @time_sheet_cost_code = TimeSheetCostCode.new
  end

  # GET /time_sheet_cost_codes/1/edit
  def edit
  end

  # POST /time_sheet_cost_codes
  # POST /time_sheet_cost_codes.json
  def create
    raise params.inspect
    
    @time_sheet_cost_code = TimeSheetCostCode.new(time_sheet_cost_code_params)

    respond_to do |format|
      if @time_sheet_cost_code.save
        format.html { redirect_to @time_sheet_cost_code, notice: 'Time sheet cost code was successfully created.' }
        format.json { render :show, status: :created, location: @time_sheet_cost_code }
      else
        format.html { render :new }
        format.json { render json: @time_sheet_cost_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /time_sheet_cost_codes/1
  # PATCH/PUT /time_sheet_cost_codes/1.json
  def update
    respond_to do |format|
      if @time_sheet_cost_code.update(time_sheet_cost_code_params)
        format.html { redirect_to @time_sheet_cost_code, notice: 'Time sheet cost code was successfully updated.' }
        format.json { render :show, status: :ok, location: @time_sheet_cost_code }
      else
        format.html { render :edit }
        format.json { render json: @time_sheet_cost_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /time_sheet_cost_codes/1
  # DELETE /time_sheet_cost_codes/1.json
  def destroy
    @time_sheet_cost_code.destroy
    respond_to do |format|
      format.html { redirect_to time_sheet_cost_codes_url, notice: 'Time sheet cost code was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_time_sheet_cost_code
      @time_sheet_cost_code = TimeSheetCostCode.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def time_sheet_cost_code_params
      params.require(:time_sheet_cost_code).permit(:cost_code, :cost_code_id, :hrs)
    end
end
