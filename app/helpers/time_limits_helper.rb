module TimeLimitsHelper
  def time_limit_in(time)
    TimeLimit.where('start <= ? AND "end" > ?', time, time).first
  end
end
