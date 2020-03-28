class PlantsController < ApplicationController
  before_action :set_plant, only: [:show, :edit, :update, :destroy]
  before_action :get_project, only: [:new, :show, :edit, :update, :create, :index]
  load_and_authorize_resource
  # GET /plants
  # GET /plants.json
  def index
    @plants = @project.plants.all
  end

  # GET /plants/1
  # GET /plants/1.json
  def show
    if params[:delete].present?
      @plant.destroy
      redirect_to plants_path
    end
  end

  # GET /plants/new
  def new
    @plant = Plant.new
  end

  # GET /plants/1/edit
  def edit
  end

  # POST /plants
  # POST /plants.json
  def create
    @plant = @project.plants.new(plant_params)
    @plant.foreman_start_date = @plant.contract_start_date
    @plant.foreman_end_date = @plant.contract_end_date
    respond_to do |format|
      if @plant.save
        format.html {redirect_to @plant, notice: 'Plant was successfully created.'}
        format.json {render :show, status: :created, location: @plant}
      else
        format.html {render :new}
        format.json {render json: @plant.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /plants/1
  # PATCH/PUT /plants/1.json
  def update

    respond_to do |format|
      if @plant.foreman_id.eql?(params[:plant][:foreman_id])
        if @plant.update(plant_params)

          format.html {redirect_to @plant, notice: 'Plant was successfully updated.'}
          format.json {render :show, status: :ok, location: @plant}
        else
          format.html {render :edit}
          format.json {render json: @plant.errors, status: :unprocessable_entity}
        end
      else
        @duplicate_record = @plant.dup
        @duplicate_record.foreman_id = params[:plant][:foreman_id]
        @duplicate_record.foreman_start_date = Date.today
        @duplicate_record.foreman_end_date = duplicate_record.contract_end_date

        if @duplicate_record.save && @plant.update(foremane_end_date: Date.today)
          format.html {redirect_to @duplicate_record, notice: 'Plant was successfully updated.'}
          format.json {render :show, status: :ok, location: @duplicate_record}
        else
          format.html {render :edit}
          format.json {render json: @duplicate_record.errors, status: :unprocessable_entity}
        end
      end
    end
  end

  # DELETE /plants/1
  # DELETE /plants/1.json
  def destroy
    @plant.destroy
    respond_to do |format|
      format.html {redirect_to plants_url, notice: 'Plant was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  def import
    file = params[:file]
    File.open(Rails.root.join('public', 'documents', file.original_filename), 'wb') do |f|
      f.write(file.read)
    end
    Plant.import(params[:file])
    redirect_to project_plants_path, notice: "created"
  end

  def download_template
    send_file(
        "#{Rails.root}/public/documents/plant_template.csv",
        filename: "plant_template.csv",
        )
  end

  private

  def get_project
    @project = Project.find(params[:project_id])
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_plant
    @plant = Plant.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def plant_params
    params.require(:plant).permit(:plant_name, :plant_id, :plant_type_id, :project_company_id,
                                  :contract_start_date, :contract_end_date, :market_value,
                                  :status, :offload)
  end
end
