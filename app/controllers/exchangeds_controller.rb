class ExchangedsController < ApplicationController
  def show
    @users = User.includes(orders: {order_details: :item}).where('orders.state = ?', Order.states['exchanged']).references(:orders)
  end

  def destroy
    update = Order.destroy_all(state: Order.states['exchanged'])
    message = {success: '商品の削除が完了しました。'} if update.any?
    redirect_to exchanged_path, flash: message
  end
end
