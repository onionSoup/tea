class ArrivedsController < ApplicationController
  def show
    #@orders = Order.includes(:user, order_details: :item).arrived
    users_allow_empty_detail = User.includes(order: {order_details: :item}).where(orders: { state: Order.states['arrived'] })
    @users = users_allow_empty_detail.reject {|user| user.order.order_details.empty? }
  end

  def exchange
    exchanged_order_count = Order.where(id: params[:order_ids]).update_all(state: Order.states[:exchanged])

    if exchanged_order_count.zero?
      redirect_to action: :show
    else
      redirect_to exchanged_path, flash: {success: '引換したことを登録しました。'}
    end
  end
end
