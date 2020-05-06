class EmployeeTimeSheetsController < ApplicationController
  before_action :get_project, only: [:index, :show]
  before_action :set_employee_time_sheet, only: [:edit, :update, :destroy]

  # GET /employee_time_sheets
  # GET /employee_time_sheets.json
  def index
    if params[:find_emp_codes].present?
      employee_time_sheet = EmployeeTimeSheet.find_by_id(params[:time_sheet_employee_id])
      employee_used_time_sheet_code = employee_time_sheet.time_sheet_cost_codes.pluck(:cost_code_id)
      # @employee_time_sheets = @project.employee_time_sheets.where(employee_create_date: Time.now.strftime("%Y-%m-%d")).order(:id)
      unused_codes_for_employee = @project.cost_codes.where('created_at < ? ', employee_time_sheet.created_at).where.not(id: employee_used_time_sheet_code, budget_holder_id: nil)
      render json: unused_codes_for_employee

    elsif params[:find_plant_codes].present?
      plant_used_time_sheet_code = @project.time_sheet_cost_codes.where(plant_id: params[:plant_id], time_sheet_plant_id: params[:time_sheet_plant_id], created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).pluck(:cost_code_id)
      @plant_time_sheets = @project.plant_time_sheets.where(employee_create_date: Time.now.strftime("%Y-%m-%d")).order(:id)
      unused_codes_for_plant = @project.cost_codes.where.not(id: plant_used_time_sheet_code)
      render json: unused_codes_for_plant

    elsif params[:date].present? && params[:search_date].present?
      @employee_time_sheets = @project.employee_time_sheets.where(employee_create_date: params[:date])
      respond_to do |format|
        format.js
        format.html
      end
    elsif params[:date].present? && params[:copy_from_previous].present?
      @employee_time_sheets_previous_data = @project.employee_time_sheets.where(employee_create_date: params[:date])
      employee_time_sheets_current_data = @project.employee_time_sheets.where(employee_create_date: params[:current_date])

      employee_ids = employee_time_sheets_current_data.pluck(:employee_id)
      if @employee_time_sheets_previous_data.present?
        @employee_time_sheets_previous_data.each do |employee_time_sheet|

          if employee_ids.include?(employee_time_sheet.employee_id)
            emp_time_sheet = employee_time_sheets_current_data.find_by_employee_id(employee_time_sheet.employee_id)
            if emp_time_sheet.present?
              emp_time_sheet.destroy
            end
          end

          company_name = employee_time_sheet.project_company.company_name rescue nil

          copied_time_sheet_data = @project.employee_time_sheets.create(employee: employee_time_sheet.employee, labour_type: employee_time_sheet.labour_type,
                                                                        project_company_id: employee_time_sheet.project_company_id, manager: employee_time_sheet.manager,
                                                                        foreman_name: employee_time_sheet.foreman_id, total_hours: employee_time_sheet.total_hours,
                                                                        employee_type_id: employee_time_sheet.employee_type_id, employee_id: employee_time_sheet.employee_id,
                                                                        employee_create_date: params[:current_date], project_id: @project.id, company: company_name)

          employee_cost_codes = employee_time_sheet.time_sheet_cost_codes

          employee_cost_codes.each do |cost_code|
            @project.time_sheet_cost_codes.create(cost_code_id: cost_code.cost_code_id, cost_code: cost_code.cost_code,
                                                  employee_id: cost_code.employee_id, hrs: cost_code.hrs,
                                                  employee_time_sheet_id: copied_time_sheet_data.id)

          end
        end
      end

      @employee_time_sheets = @project.employee_time_sheets.where(employee_create_date: params[:current_date]).order(:id)
      respond_to do |format|
        format.js
        format.html
      end
    elsif params[:total_hour].present? && params[:update_total_hour].present? && params[:data_id]
      @employee_time_sheet_data = @project.employee_time_sheets.where(id: params[:data_id]).first
      @employee_time_sheet_data.update(total_hours: params[:total_hour])
      @time_sheet_cost_code = TimeSheetCostCode.where(employee_id: @employee_time_sheet_data.employee_id, project_id: @employee_time_sheet_data.project_id,
                                                      time_sheet_employee_id: @employee_time_sheet_data.id)
      unless @time_sheet_cost_code.empty?
        devided_time = (params[:total_hour].to_f / @time_sheet_cost_code.count.to_f).round(2)
        @time_sheet_cost_code.update(hrs: devided_time)
      end
      @employee_time_sheets = @project.employee_time_sheets.where(employee_create_date: @employee_time_sheet_data.employee_create_date).order(:id)
      respond_to do |format|
        format.js
        format.html
      end
    elsif params[:submit_time_sheet].present? && params[:sheet_date].present?
      today = params[:sheet_date].to_date
      today_date = Date.today
      # if today_date.friday? || today_date.saturday? || today_date.sunday?
        whole_week = (today.at_beginning_of_week..today.at_end_of_week)
        @submitted_time_sheets = @project.employee_time_sheets.where(employee_create_date: whole_week).order(:id)
        if @submitted_time_sheets.first.submit_sheet.eql?(false)
          @submitted_time_sheets.update(submit_sheet: true)
          @result = "Time Sheet Submitted Successfully"
        elsif @submitted_time_sheets.first.submit_sheet.eql?(true)
          @result = "Time Sheet Already Submitted"
        end
      # else
      #   @result = "You can Submit Time Sheet on Friday, Saturday or Sunday"
      # end

      respond_to do |format|
        format.js
      end

      # if Time.now.strftime(" % Y - % m - % d ").to_date >= whole_week.first
      #   @time_sheet_submit_data = []
      #   condition_check = true
      #   whole_week.each do |day|
      #     time_sheet_data = EmployeeTimeSheet.where(employee_create_date: day)
      #     if !time_sheet_data.present?
      #       @employee_time_sheets = @project.employee_time_sheets.where(employee_create_date: Time.now.strftime(" % Y - % m - % d ")).order(:id)
      #       condition_check = false
      #       respond_to do |format|
      #         format.js {flash.now[:notice] = " Please Complete the Time Sheet there is no data on Date: #{day}"}
      #         format.html
      #       end
      #     elsif time_sheet_data.first.submit_sheet == true
      #       @employee_time_sheets = @project.employee_time_sheets.where(employee_create_date: Time.now.strftime("%Y-%m-%d")).order(:id)
      #       condition_check = false
      #       respond_to do |format|
      #         format.js {flash.now[:notice] = "Time Sheet Already Submitted"}
      #         format.html
      #       end
      #     else
      #       @time_sheet_submit_data.push(time_sheet_data)
      #     end
      #   end
      #   if condition_check == true
      #     @time_sheet_submit_data.each {|single_data| single_data.update(submit_sheet: true)}
      #     @employee_time_sheets = @project.employee_time_sheets.where(employee_create_date: Date.today).order(:id)
      #     respond_to do |format|
      #       format.js {flash.now[:notice] = "Time Sheet Submitted Successfully"}
      #       format.html
      #     end
      #   end
      # else
      #   @employee_time_sheets = @project.employee_time_sheets.where(employee_create_date: Date.today).order(:id)
      #   respond_to do |format|
      #     format.js {flash.now[:notice] = "You cannot Submit Time Sheet Before Date: #{whole_week.first}"}
      #     format.html
      #   end
      # end

    else
      @employee_time_sheets = @project.employee_time_sheets.where(employee_create_date: Date.today).order(:id)
    end
  end

  # GET /employee_time_sheets/1
  # GET /employee_time_sheets/1.json
  def show

    if params[:cost_code].present?
      if params[:current].present?
        @current_week_start_date = params[:current].to_date - 7
        @employee_time_sheets = @project.employee_time_sheets.where(employee_create_date: @current_week_start_date..@current_week_start_date.end_of_week(:saturday)).order(:id) rescue nil
      elsif params[:nextweek].present?
        @current_week_start_date = params[:nextweek].to_date + 7
        @employee_time_sheets = @project.employee_time_sheets.where(employee_create_date: @current_week_start_date..@current_week_start_date.end_of_week(:saturday)).order(:id) rescue nil
      else
        @employee_time_sheets = @project.employee_time_sheets.where(created_at: Date.today.beginning_of_week(:sunday)..Date.today.end_of_week(:saturday)).order(:id)
        @current_week_start_date = (Date.today.beginning_of_week(:sunday))
      end
      render 'employee_time_sheets/cost_code_time_sheet'
    else
      if params[:current].present?
        @current_week_start_date = params[:current].to_date - 7
        @employee_time_sheets = @project.employee_time_sheets.where(employee_create_date: @current_week_start_date..@current_week_start_date.end_of_week(:saturday)).order(:id) rescue nil
      elsif params[:nextweek].present?
        @current_week_start_date = params[:nextweek].to_date + 7
        @employee_time_sheets = @project.employee_time_sheets.where(employee_create_date: @current_week_start_date..@current_week_start_date.end_of_week(:saturday)).order(:id) rescue nil
      else
        @employee_time_sheets = @project.employee_time_sheets.where(created_at: Date.today.beginning_of_week(:sunday)..Date.today.end_of_week(:saturday)).order(:id)
        @current_week_start_date = (Date.today.beginning_of_week(:sunday))
      end
    end

  end

  # GET /employee_time_sheets/new
  def new
    @employee_time_sheet = EmployeeTimeSheet.new
  end

  # GET /employee_time_sheets/1/edit
  def edit
  end

  # POST /employee_time_sheets
  # POST /employee_time_sheets.json
  def create
    @employee_time_sheet = EmployeeTimeSheet.new(employee_time_sheet_params)

    respond_to do |format|
      if @employee_time_sheet.save
        format.html {redirect_to @employee_time_sheet, notice: 'Employee time sheet was successfully created.'}
        format.json {render :show, status: :created, location: @employee_time_sheet}
      else
        format.html {render :new}
        format.json {render json: @employee_time_sheet.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /employee_time_sheets/1
  # PATCH/PUT /employee_time_sheets/1.json
  def update
    respond_to do |format|
      if @employee_time_sheet.update(employee_time_sheet_params)
        format.html {redirect_to @employee_time_sheet, notice: 'Employee time sheet was successfully updated.'}
        format.json {render :show, status: :ok, location: @employee_time_sheet}
      else
        format.html {render :edit}
        format.json {render json: @employee_time_sheet.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /employee_time_sheets/1
  # DELETE /employee_time_sheets/1.json
  def destroy
    @employee_time_sheet = EmployeeTimeSheet.find(params[:id])
    @employee_time_sheet.destroy
    respond_to do |format|
      format.html {redirect_to employee_time_sheets_url, notice: 'Employee time sheet was successfully destroyed.'}
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

  def set_employee_time_sheet
    if params[:time_sheet_employee_id].present?
      @employee_time_sheet = EmployeeTimeSheet.find(params[:time_sheet_employee_id])
    else
      @employee_time_sheet = EmployeeTimeSheet.find(params[:id])
    end
  end

  # Only allow a list of trusted parameters through.
  def employee_time_sheet_params
    params.require(:employee_time_sheet).permit(:employee, :employee_id, :labour_type, :employee_type_id, :company, :project_company_id, :manager, :foreman_id, :total_hours)
  end
end
