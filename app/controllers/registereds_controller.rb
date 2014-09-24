class RegisteredsController < ApplicationController
  include Login
  before_action :need_logged_in

  def show
    @registereds = Order.registered.select_name_and_price_and_sum_of_quantity.order('nestle_index_from_the_top')

    @users = User.includes(order: {order_details: :item})
                 .order_in_state_of('registered')
                 .has_at_least_one_detail

    @total_sum = @registereds.inject(0) {|acc, order|
      acc + order.quantity * order.then_price
    }
  end

  def order
    Order.registered.where(id: OrderDetail.select('order_id')).update_all(state: Order.states['ordered'])

    redirect_to ordered_path, flash: {success: 'ネスレ公式へ注文したことを登録しました。'}
  end
end
