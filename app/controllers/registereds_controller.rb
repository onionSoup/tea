class RegisteredsController < ApplicationController
  def show
    @registereds = Order.name_price_quantity_sum(:registered)
    @total_sum = @registereds.inject(0) {|memo,order|
      memo + order.sum * order.then_price
    }
  end

  def order
    unless (Order.registered.update_all state: Order.states['ordered']) == 0
      updated_flag = true
    end
    flash[:success] = 'ネスレ公式へ注文したことを登録しました。' if updated_flag
    redirect_to ordered_path
  end
end
