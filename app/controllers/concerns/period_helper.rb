 module PeriodHelper
  extend ActiveSupport::Concern
  def period_must_be_enabled
    redirect_to period_notice_path unless Period.enabled?
  end
end
