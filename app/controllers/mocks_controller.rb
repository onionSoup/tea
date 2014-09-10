class MocksController < ApplicationController
  include Login
  include PeriodHelper

  before_action :need_logged_in

  def show
    @order = User.includes(order: {order_details: :item}).find(current_user).order
    @items = Item.order(:id)
  end

  #orders#showでできることはorder_details#indexですべてできるので、エラーメッセージを出さない。
  def reject_show_if_registered_AND_period_include_now
    redirect_to order_details_path if current_user.order.registered? && Period.include_now?
  end
end
