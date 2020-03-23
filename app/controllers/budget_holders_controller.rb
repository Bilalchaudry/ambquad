class BudgetHoldersController < ApplicationController
  before_action :set_budget_holder, only: [:show, :edit, :update, :destroy]

  # GET /budget_holders
  # GET /budget_holders.json
  def index
    @budget_holders = current_user.client_company.budget_holders
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
    @budget_holder = BudgetHolder.new(budget_holder_params)
    @budget_holder.client_company_id = current_user.client_company_id
    respond_to do |format|
      if @budget_holder.save
        format.html { redirect_to @budget_holder, notice: 'Budget holder was successfully created.' }
        format.json { render :show, status: :created, location: @budget_holder }
      else
        format.html { render :new }
        format.json { render json: @budget_holder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /budget_holders/1
  # PATCH/PUT /budget_holders/1.json
  def update
    respond_to do |format|
      if @budget_holder.update(budget_holder_params)
        format.html { redirect_to @budget_holder, notice: 'Budget holder was successfully updated.' }
        format.json { render :show, status: :ok, location: @budget_holder }
      else
        format.html { render :edit }
        format.json { render json: @budget_holder.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /budget_holders/1
  # DELETE /budget_holders/1.json
  def destroy
    @budget_holder.destroy
    respond_to do |format|
      format.html { redirect_to budget_holders_url, notice: 'Budget holder was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_budget_holder
      @budget_holder = BudgetHolder.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def budget_holder_params
      params.require(:budget_holder).permit(:employee_id, :client_company_id)
    end
end
