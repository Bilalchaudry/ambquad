class PlantTimeSheetsController < ApplicationController
  before_action :get_project, only: [:index, :show]
  before_action :set_plant_time_sheet, only: [:edit, :update, :destroy]

  # GET /plant_time_sheets
  # GET /plant_time_sheets.json
  def index
    if @project.plant_time_sheets.present?
      if params[:find_emp_codes].present?
        plant_time_sheet = PlantTimeSheet.find_by_id(params[:time_sheet_employee_id])
        plant_used_time_sheet_code = plant_time_sheet.time_sheet_cost_codes.pluck(:cost_code_id)
        unused_codes_for_plant = @project.cost_codes.where('created_at < ? ', plant_time_sheet.created_at).where.not(id: plant_used_time_sheet_code, budget_holder_id: nil)
        render json: unused_codes_for_plant

      elsif params[:find_plant_codes].present?
        plant_used_time_sheet_code = @project.time_sheet_cost_codes.where(plant_id: params[:plant_id], time_sheet_plant_id: params[:time_sheet_plant_id], created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).pluck(:cost_code_id)
        @plant_time_sheets = @project.plant_time_sheets.where(plant_create_date: Time.now.strftime("%Y-%m-%d")).order(:id)
        unused_codes_for_plant = @project.cost_codes.where.not(id: plant_used_time_sheet_code)
        render json: unused_codes_for_plant

      elsif params[:date].present? && params[:search_date].present?
        @plant_time_sheets = @project.plant_time_sheets.where(timesheet_created_at: params[:date])
        if @plant_time_sheets.present?
          if @plant_time_sheets.first.submit_sheet.eql?(false) || current_user.role.eql?("Admin")
            respond_to do |format|
              format.js
            end
          else
            render :js => "window.location = '/projects/#{@project.id}/plant_time_sheets/show'"
          end
          respond_to do |format|
            format.js
          end
        else
          respond_to do |format|
            format.js
          end
        end
      elsif params[:date].present? && params[:copy_from_previous].present?
        @plant_time_sheets_previous_data = @project.plant_time_sheets.where(timesheet_created_at: params[:date])
        plant_time_sheets_current_data = @project.plant_time_sheets.where(timesheet_created_at: params[:current_date])

        plant_ids_of_current_data = plant_time_sheets_current_data.pluck(:plant_id)
        if @plant_time_sheets_previous_data.present?
          @plant_time_sheets_previous_data.each do |plant_time_sheet|

            if plant_ids_of_current_data.include?(plant_time_sheet.plant_id)
              emp_time_sheet = plant_time_sheets_current_data.find_by_plant_id(plant_time_sheet.plant_id)
              if emp_time_sheet.present?
                emp_time_sheet.update(total_hours: plant_time_sheet.total_hours)
                emp_time_sheet.time_sheet_cost_codes.delete_all
                plant_cost_codes = plant_time_sheet.time_sheet_cost_codes

                plant_cost_codes.each do |cost_code|
                  TimeSheetCostCode.create(cost_code_id: cost_code.cost_code_id, cost_code: cost_code.cost_code,
                                           plant_id: cost_code.plant_id, hrs: cost_code.hrs,
                                           plant_time_sheet_id: emp_time_sheet.id,
                                           project_id: @project.id, cost_code_created_at: params[:current_date])
                end

              end
            end
          end
        end

        @plant_time_sheets = @project.plant_time_sheets.where(timesheet_created_at: params[:current_date]).order(:id)
        respond_to do |format|
          format.js
          format.html
        end
      elsif params[:total_hour].present? && params[:update_total_hour].present? && params[:data_id]
        @plant_time_sheet_data = @project.plant_time_sheets.where(id: params[:data_id]).first
        @plant_time_sheet_data.update(total_hours: params[:total_hour])
        @time_sheet_cost_code = TimeSheetCostCode.where(plant_id: @plant_time_sheet_data.plant_id, project_id: @project.id,
                                                        time_sheet_plant_id: @plant_time_sheet_data.id)
        unless @time_sheet_cost_code.empty?
          devided_time = (params[:total_hour].to_f / @time_sheet_cost_code.count.to_f).round(2)
          @time_sheet_cost_code.update(hrs: devided_time)
        end
        @plant_time_sheets = @project.plant_time_sheets.where(timesheet_created_at: @plant_time_sheet_data.timesheet_created_at).order(:id)
        respond_to do |format|
          format.js
          format.html
        end
      elsif params[:submit_time_sheet].present? && params[:sheet_date].present?
        today = params[:sheet_date].to_date
        today_date = Date.today
        if today_date.friday? || today_date.saturday? || today_date.sunday?
          whole_week = (today.at_beginning_of_week..today.at_end_of_week)
          @submitted_time_sheets = @project.plant_time_sheets.where(timesheet_created_at: whole_week).order(:id)
          if @submitted_time_sheets.first.submit_sheet.eql?(false)
            @submitted_time_sheets.update(submit_sheet: true)
            @result = "Time Sheet Submitted Successfully"
          elsif @submitted_time_sheets.first.submit_sheet.eql?(true)
            @result = "Time Sheet Already Submitted"
          end
        else
          @result = "You can Submit Time Sheet on Friday, Saturday or Sunday"
        end

        respond_to do |format|
          format.js
        end

      elsif params[:next_week_time_sheet].present?
        date = @project.plant_time_sheets.order(:timesheet_created_at).last.timesheet_created_at
        plant_create_date = date
        (1..7).to_a.reverse.each do |day|

          project_plants = @project.plants.where(status: "Active").where.not(foreman_id: nil)
          if project_plants.present?
            plant_create_date = plant_create_date + 1
            search_date = plant_create_date - 7

            project_plants.each do |plant|
              manager_name = plant.other_managers.plant.plant_name rescue nil
              foreman_name = Employee.find_by_id(Foreman.find_by_id(plant.foreman_id).plant_id).plant_name rescue nil
              company_name = plant.project_company.company_name rescue nil


              previous_plant_time_sheet = @project.plant_time_sheets.where(plant_id: plant.id,
                                                                           timesheet_created_at: search_date).first

              sheet_hours = previous_plant_time_sheet.total_hours rescue 0
              plant_time_sheets = @project.plant_time_sheets.create(plant_name: plant.plant_type.type_name,
                                                                    project_company_id: plant.project_company_id, company: company_name,
                                                                    manager: manager_name, foreman_name: foreman_name, foreman_id: plant.foreman_id,
                                                                    total_hours: sheet_hours, timesheet_created_at: plant_create_date, project_id: @project.id,
                                                                    plant_id: plant.id)

              if previous_plant_time_sheet.present?
                plant_cost_codes = previous_plant_time_sheet.time_sheet_cost_codes.where(plant_time_sheet_id: previous_plant_time_sheet.id)

                plant_cost_codes.each do |cost_code|
                  @project.time_sheet_cost_codes.create(cost_code_id: cost_code.cost_code_id, cost_code: cost_code.cost_code,
                                                        plant_id: cost_code.plant_id, hrs: cost_code.hrs,
                                                        plant_time_sheet_id: plant_time_sheets.id)

                end
              end
            end
          end
        end
        @plant_time_sheets = @project.plant_time_sheets.where(timesheet_created_at: date).order(:id)

      else
        non_submitted_sheets = @project.plant_time_sheets.where(submit_sheet: false).order(:id)
        if non_submitted_sheets.present?
          @plant_time_sheets = @project.plant_time_sheets.where(timesheet_created_at: non_submitted_sheets.first.timesheet_created_at).order(:id)
        else
          if current_user.role.eql?("User")
            redirect_to '/projects/' + @project.id.to_s + '/plant_time_sheets/show'
          else
            @plant_time_sheets = @project.plant_time_sheets.where(timesheet_created_at: Date.today).order(:id)
          end
        end
      end
    else
      date = Date.today
      timesheet_created_at = date
      number_of_remaining_week_days = (Date.today.end_of_week(:monday) - Date.today).to_i

      (1..number_of_remaining_week_days).to_a.reverse.each do |day|

        project_plants = @project.plants.where(status: "Active")
        if project_plants.present?
          project_plants.each do |plant|
            manager_name = plant.other_managers.plant.plant_name rescue nil
            foreman_name = Employee.find_by_id(Foreman.find_by_id(plant.foreman_id).plant_id).employee_name rescue nil
            company_name = plant.project_company.company_name rescue nil
            plant_time_sheets = @project.plant_time_sheets.create(plant_name: plant.plant_type.type_name,
                                                                  project_company_id: plant.project_company_id, company: company_name,
                                                                  manager: manager_name, foreman_name: foreman_name, foreman_id: plant.foreman_id,
                                                                  total_hours: 0, timesheet_created_at: timesheet_created_at, project_id: @project.id,
                                                                  plant_id: plant.id)

          end
          timesheet_created_at = timesheet_created_at + 1
        end
      end
      @plant_time_sheets = @project.plant_time_sheets.where(timesheet_created_at: Date.today).order(:id)
    end
  end

  # GET /plant_time_sheets/1
  # GET /plant_time_sheets/1.json
  def show
    if params[:cost_code].present?
      @today_date = params[:date].present? ? Date.parse(params[:date]) : Date.today
      @plant_time_sheets = @project.plant_time_sheets.where(timesheet_created_at: @today_date)
      @timesheet_plant_ids = @plant_time_sheets.pluck(:plant_id).uniq
      render 'plant_time_sheets/cost_code_time_sheet'
    else
      if params[:current].present?
        @current_week_start_date = params[:current].to_date - 7
        @plant_time_sheets = @project.plant_time_sheets.where(timesheet_created_at: @current_week_start_date..@current_week_start_date.end_of_week(:sunday))
      elsif params[:nextweek].present?
        @current_week_start_date = params[:nextweek].to_date + 7
        @plant_time_sheets = @project.plant_time_sheets.where(timesheet_created_at: @current_week_start_date..@current_week_start_date.end_of_week(:sunday))
      else
        @plant_time_sheets = @project.plant_time_sheets.where(timesheet_created_at: Date.today.beginning_of_week(:sunday)..Date.today.end_of_week(:sunday))
        @current_week_start_date = (Date.today.beginning_of_week(:sunday))
      end
      @timesheet_plant_ids = @plant_time_sheets.pluck(:plant_id).uniq
    end
  end

  # GET /plant_time_sheets/new
  def new
    @plant_time_sheet = PlantTimeSheet.new
  end

  # GET /plant_time_sheets/1/edit
  def edit
  end

  # POST /plant_time_sheets
  # POST /plant_time_sheets.json
  def create
    @plant_time_sheet = PlantTimeSheet.new(plant_time_sheet_params)

    respond_to do |format|
      if @plant_time_sheet.save
        format.html {redirect_to @plant_time_sheet, notice: 'Plant time sheet was successfully created.'}
        format.json {render :show, status: :created, location: @plant_time_sheet}
      else
        format.html {render :new}
        format.json {render json: @plant_time_sheet.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /plant_time_sheets/1
  # PATCH/PUT /plant_time_sheets/1.json
  def update
    respond_to do |format|
      if @plant_time_sheet.update(plant_time_sheet_params)
        format.html {redirect_to @plant_time_sheet, notice: 'Plant time sheet was successfully updated.'}
        format.json {render :show, status: :ok, location: @plant_time_sheet}
      else
        format.html {render :edit}
        format.json {render json: @plant_time_sheet.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /plant_time_sheets/1
  # DELETE /plant_time_sheets/1.json
  def destroy
    @plant_time_sheet.destroy
    respond_to do |format|
      format.html {redirect_to plant_time_sheets_url, notice: 'Plant time sheet was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def get_project
    @project = Project.find(params[:project_id])
    @cost_codes = @project.cost_codes rescue nil
    used_cost_code = @project.time_sheet_cost_codes.all.pluck(:cost_code_id)
    @project_cost_codes = @cost_codes.where.not(id: used_cost_code) rescue nil
  end

  def set_plant_time_sheet
    @plant_time_sheet = PlantTimeSheet.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def plant_time_sheet_params
    params.require(:plant_time_sheet).permit(:plant_id, :plant_name, :plant_id, :company, :project_company_id, :manager, :foreman_id, :total_hours)
  end
end
