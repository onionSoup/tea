module AdminStatus
  def admin_cart_position_names(nothing_added: false)
    if nothing_added
      %w(期間設定 注文待ち 発注 発送待ち 引換  終了処理 注文なし)
    else
      %w(期間設定 注文待ち 発注 発送待ち 引換 終了処理)
    end
  end

  def admin_status_with_period
    return 'undefined_period' if Period.has_undefined_times?

    if Order.all.all? {|order| order.registered? }
      return 'can_add_detail' if Period.include_now?
      if Order.all.any? {|order| order.non_empty_order?}
        return 'wait_ordered'
      else
        raise 'must be nothing_added' unless Order.all.all? {|order| order.empty_order? }
        return 'nothing_added'
      end
    end

    return 'ordered' if Order.all.any? {|order| order.ordered? }
    return 'arrived' if Order.all.any? {|order| order.arrived? }
    return 'finish'  if Order.all.all? {|order| order.anexchanged? || order.empty_order? }
  end
end
