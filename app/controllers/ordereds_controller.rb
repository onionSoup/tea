class OrderedsController < ApplicationController
  def show
    @ordereds = Order.ordered.select_name_and_price_and_sum_of_quantity

    @users = User.includes(order: {order_details: :item})
                 .order_in_state_of('ordered')
                 .has_at_least_one_detail

    @total_sum = @ordereds.inject(0) {|memo, order|
      memo + order.quantity * order.then_price
    }
  end

  def arrive
    updated = Order.ordered.update_all(state: Order.states['arrived']).nonzero?

    if updated
      redirect_to arrived_path, flash: {success: 'ネスレからお茶が届いたことを登録しました。'}
    else
      redirect_to ordered_path
    end
  end
end
