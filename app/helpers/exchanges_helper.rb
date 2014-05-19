module ExchangesHelper

  def first_false_exchange
    e = Exchange.joins(:time_limit).where('exchange_flag =?', false).order('start DESC')
    case e.size
      when 1
        if  in_now_time_limit?(e.first)
          #まだ注文募集中なので、引換ができない
          flash[:exchange] = '現在引換すべきものはありません'
        end
        return e.first
      when 2
        if  in_now_time_limit?(e.second)
          #最新のexchangeは注文募集中。その前は引換可能
          flash[:exchange_success] ='正常に引換が可能です。'
          return e.first
        else
          #前回と前々回の引換が、両方とも終わってない。
          flash[:exchange_success] = '未引換の注文情報が複数あります。最も古いものを表示します。'
          return e.first
        end
      when 3..1000000
        flash[:exchange_success] = '未引換の注文情報が複数あります。最も古いものを表示します。'
          return e.first
      else
        flash[:exchange] = '現在引換すべきものはありません'
        return nil
    end
  end

  def in_now_time_limit?(exchange)
    st = exchange.time_limit.start
    en = exchange.time_limit.end
    st <= Date.today && Date.today < en
  end
end
