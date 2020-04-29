class HistoryController < ApplicationController

  def index
    @audits = Audited.audit_class.all.limit(15)
  end

end