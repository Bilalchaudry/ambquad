class PlantTypesController < ApplicationController
  before_action :set_plant_type, only: [:show, :edit, :update, :destroy]

  # GET /plant_types
  # GET /plant_types.json
  def index
    @plant_types = PlantType.all
  end

  # GET /plant_types/1
  # GET /plant_types/1.json
  def show
  end

  # GET /plant_types/new
  def new
    @plant_type = PlantType.new
  end

  # GET /plant_types/1/edit
  def edit
  end

  # POST /plant_types
  # POST /plant_types.json
  def create
    @plant_type = PlantType.new(plant_type_params)

    respond_to do |format|
      if @plant_type.save
        format.html { redirect_to @plant_type, notice: 'Plant type was successfully created.' }
        format.json { render :show, status: :created, location: @plant_type }
      else
        format.html { render :new }
        format.json { render json: @plant_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plant_types/1
  # PATCH/PUT /plant_types/1.json
  def update
    respond_to do |format|
      if @plant_type.update(plant_type_params)
        format.html { redirect_to @plant_type, notice: 'Plant type was successfully updated.' }
        format.json { render :show, status: :ok, location: @plant_type }
      else
        format.html { render :edit }
        format.json { render json: @plant_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plant_types/1
  # DELETE /plant_types/1.json
  def destroy
    @plant_type.destroy
    respond_to do |format|
      format.html { redirect_to plant_types_url, notice: 'Plant type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plant_type
      @plant_type = PlantType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def plant_type_params
      params.require(:plant_type).permit(:type_name)
    end
end
