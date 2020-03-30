class PlantTypesController < ApplicationController
  before_action :set_plant_type, only: [:show, :edit, :update, :destroy]
  before_action :get_project, only: [:new, :show, :edit, :update, :create, :index, :destroy]
  load_and_authorize_resource

  # GET /plant_types
  # GET /plant_types.json
  def index
    @plant_types = @project.plant_types
  end

  # GET /plant_types/1
  # GET /plant_types/1.json
  def show
    if params[:delete].present?
      @plant_type.destroy
      redirect_to project_plant_types_path
    end
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
    @plant_type = @project.plant_types.new(plant_type_params)

    respond_to do |format|
      if @plant_type.save
        format.html {redirect_to "/projects/#{@project.id}/plant_types", notice: 'Plant type was successfully created.'}
        format.json {render :show, status: :created, location: @plant_type}
      else
        format.html {render :new}
        format.json {render json: @plant_type.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /plant_types/1
  # PATCH/PUT /plant_types/1.json
  def update
    respond_to do |format|
      if @plant_type.update(plant_type_params)
        format.html {redirect_to "/projects/#{@project.id}/plant_types", notice: 'Plant type was successfully updated.'}
        format.json {render :show, status: :ok, location: @plant_type}
      else
        format.html {render :edit}
        format.json {render json: @plant_type.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /plant_types/1
  # DELETE /plant_types/1.json
  def destroy
    @plant_type.destroy
    respond_to do |format|
      format.html {redirect_to "/projects/#{@project.id}/plant_types", notice: 'Plant type was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  def import
    file = params[:file]
    File.open(Rails.root.join('public', 'documents', file.original_filename), 'wb') do |f|
      f.write(file.read)
    end
    errors = PlantType.import(params[:file])
    if errors == false
      flash[:notice] = 'File Format not Supported'
    else
      flash[:notice] = 'File has been imported successfully.'
    end
    redirect_to project_plant_types_path
  end

  def download_template
    send_file(
        "#{Rails.root}/public/documents/plant_type_template.csv",
        filename: "plant_type_template.csv",
    )
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def set_plant_type
    @plant_type = PlantType.find(params[:id])
  end

  def get_project
    @project = Project.find(params[:project_id])
  end

  # Only allow a list of trusted parameters through.
  def plant_type_params
    params.require(:plant_type).permit(:type_name)
  end
end
