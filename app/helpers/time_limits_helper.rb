module TimeLimitsHelper

  def now_time_limit_id
    now = Time.now.midnight
    #whereはActiveRecordObjectのArrayを返す。そのためwhere.idではなくfirstが間に必要。
    TimeLimit.where('start <= ? AND "end" > ?', now, now).first.id
  end

end
