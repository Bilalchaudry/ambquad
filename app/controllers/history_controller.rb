class HistoryController < ApplicationController

  def index
    @audits = Audited.audit_class.order('id DESC').paginate(page: params[:page], per_page: 30)
  end

end