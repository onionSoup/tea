module AdminOrdersHelper
  #これ３つのメソッドに分けたほうが読みやすいかも
  #そもそも１行くらいならビューでやってもいいのかも
  def name_price_quantity_sum
    Order.joins(order_details: :item).group("items.id").select("items.name, items.price, SUM(quantity)")
  end

  def price_sum
    sum = 0
    time_limit_in(Time.now).orders.each do |o|
      o.order_details.each do |od|
        sum += od.item.price * od.quantity
      end
    end
    return sum
  end
end
