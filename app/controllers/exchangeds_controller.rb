class ExchangedsController < ApplicationController
  def show
    @users = User.includes(order: {order_details: :item}).where(orders: {state: Order.states['exchanged']})
  end

  def destroy
    orders = Order.where(state: Order.states['exchanged'])
    users  = orders.map {|order| order.user }

    #常に１Userは１Orderを持つ仕様。
    users.each do |user|
      Order.destroy user.order
      user.create_order
    end

    Period.singleton_instance.destroy if Period.can_destroy?
    
    message = {success: '商品の削除が完了しました。'} if orders.present?

    redirect_to exchanged_path, flash: message
  end
end
