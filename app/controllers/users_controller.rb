class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]
  # load_and_authorize_resource
  # GET /users
  # GET /users.json
  def index
    Project.all.each do |project|
      date = Date.today
      employee_create_date = date
      if date.tuesday?
        if project.employee_time_sheets.present?
          (1..6).to_a.reverse.each do |day|
            employee_create_date = employee_create_date + 1
            search_date = employee_create_date - 7
            project.employees.where.not(foreman_id: nil).each do |employee|
              create_time_sheet_employee(project, employee, search_date, employee_create_date)
            end
          end
        elsif project.project_companies.present? &&
            project.employees.present? && project.employees.where(foreman_id: nil).blank? &&
            project.plants.present? && project.plants.where(foreman_id: nil).blank? &&
            project.foremen.present? &&
            project.budget_holders.present? &&
            project.cost_codes.present? && project.cost_codes.where(budget_holder_id: nil).blank? &&
            project.crews.present?

          (1..6).to_a.reverse.each do |day|

            project_employees = project.employees
            if project_employees.present?
              employee_create_date = employee_create_date + 1
              search_date = employee_create_date - 7

              project_employees.each do |employee|
                create_time_sheet_employee(project, employee, search_date, employee_create_date)
              end
            end

          end
        end
      end
    end

  end


  def create_time_sheet_employee(project, employee, search_date, employee_create_date)
    manager_name = employee.other_managers.employee.employee_name rescue nil
    foreman_name = employee.foreman.employee.employee_name rescue nil
    company_name = employee.project_company.company_name rescue nil


    previous_employee_time_sheet = project.employee_time_sheets.where(employee_id: employee.id,
                                                                      employee_create_date: search_date).first

    sheet_hours = previous_employee_time_sheet.total_hours rescue 0
    employee_time_sheets = project.employee_time_sheets.create(employee: employee.employee_name, labour_type: employee.employee_type.employee_type,
                                                               project_company_id: employee.project_company_id, company: company_name,
                                                               manager: manager_name, foreman_name: foreman_name, foreman_id: employee.foreman_id,
                                                               total_hours: sheet_hours, employee_type_id: employee.employee_type_id,
                                                               employee_create_date: employee_create_date, project_id: project.id, employee_id: employee.id)

    if previous_employee_time_sheet.present?
      employee_cost_codes = previous_employee_time_sheet.time_sheet_cost_codes.where(employee_time_sheet_id: previous_employee_time_sheet.id)

      employee_cost_codes.each do |cost_code|
        project.time_sheet_cost_codes.create(cost_code_id: cost_code.cost_code_id, cost_code: cost_code.cost_code,
                                             employee_id: cost_code.employee_id, hrs: cost_code.hrs,
                                             employee_time_sheet_id: employee_time_sheets.id)

      end
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if params[:id] == "0"
      sign_out(current_user)
      redirect_to root_path
    elsif params[:delete].present?
      @user = User.find(params[:id])
      @user.destroy
      redirect_to users_path
    else
      @user = User.find_by_id(params[:id])
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    # user_company_id = @user.client_company_id
    # @user_company = ClientCompany.find(user_company_id) rescue nil
    # @client_companies = ClientCompany.all.where.not(id: @user.client_company_id) rescue nil
    # puts "ok"
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html {redirect_to @user, notice: 'User was successfully created.'}
        format.json {render :show, status: :created, location: @user}
      else
        format.html {render :new}
        format.json {render json: @user.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      client_company_change = @user.client_company_id == params[:user][:client_company_id].to_i
      unless client_company_change
        previous_client_company = @user.client_company
      end
      if @user.update(user_update_params)
        unless client_company_change
          @user.client_company.update(number_of_users: @user.client_company.number_of_users + 1)
          previous_client_company.update(number_of_users: previous_client_company.number_of_users - 1)
        end

        if params[:user][:password].present? && params[:user][:password_confirmation].present? && params[:user][:password] == params[:user][:password_confirmation]
          @user.update(password: params[:user][:password], password_confirmation: params[:user][:confirm_password])
        end
        format.html {redirect_to users_path, notice: 'User was successfully updated.'}
        format.json {render :show, status: :ok, location: @user}
      else
        format.html {render :edit}
        format.json {render json: @user.errors, status: :unprocessable_entity}
      end
    end
  end

  def confirm_email
    user = User.find_by_confirm_token(params[:token])
    if user
      # user.validate_email
      user.save(validate: false)
      flash[:alert] = "Sorry. User does not exist"

      redirect_to root_url, alert: "324234"
    else
      flash[:error] = "Sorry. User does not exist"
      redirect_to root_url
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    begin
      TemporaryUser.find_by_email(@user.email).destroy rescue nil
      @user.client_company.update(number_of_users: @user.client_company.number_of_users - 1)
      @user.destroy
      @destroy = true

    rescue => e
      redirect_to users_path, notice: 'User can not deleted because it is linked with its assosiative records'
    end

  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone_no, :email, :username,
                                 :role, :company_id, :encrypted_password, :password)
  end


  def user_update_params
    pp = params.require(:user).permit(:first_name, :last_name, :phone_no, :email, :username,
                                      :phone_country_code, :client_company_id, :country_name,
                                      :status, :user_id, :phone_country_code, :role, :status)
    pp[:role] = params[:user][:role].to_i
    pp[:status] = params[:user][:status].to_i
    return pp
  end

  def update_params
    pp = params.require(:user).permit(:first_name, :last_name, :phone_no, :email, :username,
                                      :phone_country_code, :password, :encrypted_password,
                                      :client_company_id, :country_name, :user_id,
                                      :phone_country_code, :confirm_password, :role, :status,
                                      :password_confirmation)
    pp[:role] = params[:user][:role].to_i
    pp[:status] = params[:user][:status].to_i
    return pp
  end
end
