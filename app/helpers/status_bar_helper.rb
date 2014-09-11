module StatusBarHelper
  def user_cart_position(order)
    return 0 if Period.has_undefined_times?

    if order.registered?
      return 1 if Period.include_now?
      if order.non_empty_order?
        return 2
      else
        hash = {order: order.state, period: Period.state, detail: order.non_empty_order?}
        raise 'wrong condition' unless hash == {order: 'registered', period: :out_of_date, detail: false}
        return 'not_a_number. cart is in second line'
      end
    end
    return 3 if order.ordered?
    return 4 if order.arrived?
    return 5 if order.exchanged?
  end
end
