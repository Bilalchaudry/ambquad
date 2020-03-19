class TemporaryUsersController < ApplicationController
  before_action :set_temporary_user, only: [:show, :edit, :update, :destroy]

  # GET /temporary_users
  # GET /temporary_users.json
  def index
    @temporary_users = TemporaryUser.all
  end

  # GET /temporary_users/1
  # GET /temporary_users/1.json
  def show
  end

  # GET /temporary_users/new
  def new
    @temporary_user = TemporaryUser.new
  end

  # GET /temporary_users/1/edit
  def edit
  end

  # POST /temporary_users
  # POST /temporary_users.json
  def create

    @temporary_user = TemporaryUser.new(temporary_user_params)
    code = ISO3166::Country.find_country_by_name(@temporary_user.country_name).country_code
    @temporary_user.phone_no = '+' + code + @temporary_user.phone_no

    @user = User.new(temporary_user_params)
    @user.phone_no = '+' + code + @user.phone_no
    @user.save

    @user.set_confirmation_token
    @user.save(validate: false)
    MailSendJob.perform_later(@user)
    # UserMailer.registration_confirmation(@user).deliver_now

    respond_to do |format|
      if @temporary_user.save
        format.html {redirect_to @user, notice: 'Temporary user was successfully created.'}
        format.json {render :show, status: :created, location: @temporary_user}
      else
        format.html {render :new}
        format.json {render json: @temporary_user.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /temporary_users/1
  # PATCH/PUT /temporary_users/1.json
  def update
    respond_to do |format|
      if @temporary_user.update(temporary_user_params)
        format.html {redirect_to @temporary_user, notice: 'Temporary user was successfully updated.'}
        format.json {render :show, status: :ok, location: @temporary_user}
      else
        format.html {render :edit}
        format.json {render json: @temporary_user.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /temporary_users/1
  # DELETE /temporary_users/1.json
  def destroy
    @temporary_user.destroy
    respond_to do |format|
      format.html {redirect_to temporary_users_url, notice: 'Temporary user was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_temporary_user
    @temporary_user = TemporaryUser.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def temporary_user_params
    pp = params.require(:temporary_user).permit(:first_name, :last_name, :phone_no, :email, :username,
                                                :password, :encrypted_password, :client_company_id, :country_name, :active_user, :email_confirmed, :confirm_token)
    pp[:role] = params[:temporary_user][:role].to_i
    return pp
  end
end
