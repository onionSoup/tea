module AdminOrdersHelper
  #これ３つのメソッドに分けたほうが読みやすいかも
  #そもそも１行くらいならビューでやってもいいのかも
  def name_price_quantity_sum
    Order.joins(order_details: :item).group("items.id").select("items.name, items.price, SUM(quantity)")
  end

  def price_sum
    sum = 0
    time_limit_in(Time.now).orders.each do |o|
      sum += price_sum_of_this_order(o)
    end
    return sum
  end

  def price_sum_of_this_order(order)
    sum  = 0
    order.order_details.each do |detail|
      sum += detail.quantity * detail.item.price
    end
    return sum
  end
end
