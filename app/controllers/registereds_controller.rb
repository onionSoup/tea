class RegisteredsController < ApplicationController
  before_action :prihibit_browser_form_caching_page, only: [:show]

  def show
    @registereds = Order.registered.select_name_and_price_and_sum_of_quantity

    @total_sum = @registereds.inject(0) {|memo,order|
      memo + order.quantity * order.then_price
    }
  end

  def order
    updated = Order.registered
                   .where(id: OrderDetail.select('order_id'))#.reject {|one_order| one_order.order_details.empty? }がarray返すので書いたが自信がない。
                   .update_all(state: Order.states['ordered'])
                   .nonzero?
    if updated
      flash[:success] = 'ネスレ公式へ注文したことを登録しました。'
      redirect_to ordered_path
    else
      redirect_to registered_path
    end
  end
end
