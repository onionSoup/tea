class OrderedsController < ApplicationController
  def show
    @ordereds = Order.name_price_quantity_sum(:ordered)
    @total_sum = @ordereds.inject(0) {|memo,order|
      memo + order.sum * order.then_price
    }
  end

  def arrive
    unless (Order.ordered.update_all state: Order.states['arrived']) == 0
      updated_flag = true
    end
    flash[:success] = 'ネスレからお茶が届いたことを登録しました。' if updated_flag
    redirect_to arrived_path
  end
end
