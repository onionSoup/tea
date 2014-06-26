class ExchangedsController < ApplicationController
  before_action :prihibit_browser_form_caching_page, only: [:show]

  def show
    @users = User.includes(order: {order_details: :item}).where(orders: {state: Order.states['exchanged']})
  end

  def destroy
    update = Order.destroy_all(state: Order.states['exchanged'])
    message = {success: '商品の削除が完了しました。'} if update.any?

    redirect_to exchanged_path, flash: message
  end
end
