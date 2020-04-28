class HistoryController < ApplicationController

  def index
    @audits = Audited.audit_class.all
  end

end