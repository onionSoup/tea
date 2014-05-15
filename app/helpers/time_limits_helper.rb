module TimeLimitsHelper

#TimeLimit.where〜の共通部分をくくることはできる。
#でも１行だけなので、くくるとかえってダメな気がする。
  def now_time_limit_id
    now = Time.now.midnight
    #whereはActiveRecordObjectのArrayを返す。そのためwhere.idではなくfirstが間に必要。
    TimeLimit.where('start <= ? AND "end" > ?', now, now).first.id
  end

##後でDRYにする。
##追記：time_to_admin(now)をよく使うので、最初から引数なしでnowの方が良かったかも
  def time_to_admin(time)
    t_limit = TimeLimit.where('start <= ? AND "end" > ?', time, time).first
    t_limit.admin_order
  end

###さらに追記：結局これが必要になった
###つまり結論は、このメソッドだけで良かった。
  def time_limit_in(time)
    TimeLimit.where('start <= ? AND "end" > ?', time, time).first
  end
end
