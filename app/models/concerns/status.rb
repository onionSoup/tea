module Status
  def cart_position_names(nothing_added: false)
    if nothing_added
      %w(募集待ち 注文可能 発注待ち 発送待ち 引換可能 引換済み 注文なし)
    else
      %w(募集待ち 注文可能 発注待ち 発送待ち 引換可能 引換済み)
    end
  end

  def status_with_period
    return 'undefined_period' if Period.has_undefined_times?

    if registered?
      return 'can_add_detail' if Period.include_now?
      if non_empty_order?
        return 'wait_ordered'
      else
        hash = {order: state, period: Period.state, detail: non_empty_order?}
        raise 'wrong condition' unless hash == {order: 'registered', period: :out_of_date, detail: false}
        return 'nothing_added'
      end
    end

    return 'ordered'   if ordered?
    return 'arrived'   if arrived?
    return 'exchanged' if exchanged?
  end
end
