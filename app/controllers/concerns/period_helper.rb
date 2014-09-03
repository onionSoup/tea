 module PeriodHelper
  extend ActiveSupport::Concern

  def period_must_have_defined_times
    redirect_to period_notice_path if Period.has_undefined_times?
  end
end
