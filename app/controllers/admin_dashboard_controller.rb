class AdminDashboardController < ApplicationController
  before_action :authenticate_admin_user!

  def dashboard

  end

end
