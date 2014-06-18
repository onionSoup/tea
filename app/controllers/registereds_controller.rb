class RegisteredsController < ApplicationController
  def show
    @registereds = Order.registered.name_price_quantity_sum

    @total_sum = @registereds.inject(0) {|memo,order|
      memo + order.quantity * order.then_price
    }
  end

  def order
    updated = Order.registered.update_all(state: Order.states['ordered']).nonzero?
    if updated
      flash[:success] = 'ネスレ公式へ注文したことを登録しました。'
      redirect_to ordered_path
    else
      redirect_to registered_path
    end
  end
end