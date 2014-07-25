class OrdersController < ApplicationController
  before_action :need_signed_in
  before_action :reject_show_until_ordered, only: [:show]

  include Signin

  def show
    @order = User.includes(order: {order_details: :item}).find(current_user).order
  end

  def reject_show_until_ordered
    #orders#showでできることはorder_details#indexですべてできるので、エラーメッセージを出さない。
    redirect_to order_details_path if current_user.order.state == 'registered'
  end
end
