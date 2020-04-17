class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]
  # load_and_authorize_resource
  # GET /users
  # GET /users.json
  def index
    @users = User.all
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
    user_company_id = @user.client_company_id
    @user_company = ClientCompany.find(user_company_id) rescue nil
    @client_companies = ClientCompany.all.where.not(id: @user.client_company_id) rescue nil
    puts "ok"
  end

  # POST /users
  # POST /users.json
  # def create
  #   @user = User.new(user_params)
  #
  #   respond_to do |format|
  #     if @user.save
  #       format.html {redirect_to @user, notice: 'User was successfully created.'}
  #       format.json {render :show, status: :created, location: @user}
  #     else
  #       format.html {render :new}
  #       format.json {render json: @user.errors, status: :unprocessable_entity}
  #     end
  #   end
  # end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(update_params)
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
      user.validate_email
      user.save(validate: false)
      redirect_to root_url
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

  def update_params
    pp = params.require(:user).permit(:first_name, :last_name, :phone_no,
                                      :email, :username, :encrypted_password,
                                      :password, :status, :client_company_id)
    pp[:role] = params[:user][:role].to_i
    pp[:status] = params[:user][:status].to_i
    return pp
  end
end
