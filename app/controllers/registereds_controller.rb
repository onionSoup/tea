class RegisteredsController < ApplicationController
  def show
    @registereds = Order.registered.select_name_and_price_and_sum_of_quantity

    @total_sum = @registereds.inject(0) {|acc, order|
      acc + order.quantity * order.then_price
    }
  end

  def order
    updated = Order.registered
                   .where(id: OrderDetail.select('order_id'))
                   .update_all(state: Order.states['ordered'])
                   .nonzero?
    if updated
      redirect_to ordered_path, flash: {success: 'ネスレ公式へ注文したことを登録しました。'}
    else
      redirect_to registered_path
    end
  end
end
