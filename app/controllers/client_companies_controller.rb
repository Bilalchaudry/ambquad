class ClientCompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]
  # load_and_authorize_resource

  # GET /companies
  # GET /companies.json
  def index
    @companies = ClientCompany.all
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
    if params[:delete].present?
      @client_company.destroy
      redirect_to client_companies_path
    end
  end

  # GET /companies/new
  def new
    @client_company = ClientCompany.new
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies
  # POST /companies.json
  def create
    @client_company = ClientCompany.new(company_params)
    @client_company.phone_country_code = ISO3166::Country.find_country_by_name(@client_company.country_name).country_code rescue "N/A"
    @client_company.primary_poc_country_code = ISO3166::Country.find_country_by_name(@client_company.poc_country).country_code rescue "N/A"

    respond_to do |format|
      if @client_company.save
        format.html {redirect_to client_companies_url, notice: 'Company is successfully created.'}
        format.json {render :show, status: :created, location: @client_company}
      else
        format.html {render :new}
        format.json {render json: @client_company.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @client_company.update(company_params)
        format.html {redirect_to @client_company, notice: 'Company was successfully updated.'}
        format.json {render :show, status: :ok, location: @client_company}
      else
        format.html {render :edit}
        format.json {render json: @client_company.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    begin
      if @client_company.projects.present?
        respond_to do |format|
          format.js
        end
      else
        @client_company.destroy
        @destroy = true
        respond_to do |format|
          format.js
        end
      end
    rescue => e
      redirect_to projects_path, notice: 'Project can not deleted because it is linked with its assosiative records'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_company
    @client_company = ClientCompany.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def company_params
    params.require(:client_company).permit(:company_name, :address, :phone, :number_of_users,
                                           :primary_poc_first_name, :primary_poc_last_name, :poc_email,
                                           :poc_phone, :status, :client_po_number, :closed_at,
                                           :country_name, :poc_country, :company_id)
  end
end
