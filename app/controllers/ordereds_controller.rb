class OrderedsController < ApplicationController
  def show
    @ordereds = Order.ordered.name_price_quantity_sum

    @total_sum = @ordereds.inject(0) {|memo,order|
      memo + order.quantity * order.then_price
    }
  end

  def arrive
    updated = Order.ordered.update_all(state: Order.states['arrived']).nonzero?
    if updated
      flash[:success] = 'ネスレからお茶が届いたことを登録しました。'
      redirect_to arrived_path
    else
      redirect_to ordered_path
    end
  end
end
