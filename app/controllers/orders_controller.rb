class OrdersController < ApplicationController
  include Login
  include PeriodHelper

  before_action :need_logged_in
  before_action :reject_show_until_ordered, only: [:show]
  before_action :period_must_be_enabled,    only: [:show]

  def show
    @order = User.includes(order: {order_details: :item}).find(current_user).order
  end

  def reject_show_until_ordered
    #orders#showでできることはorder_details#indexですべてできるので、エラーメッセージを出さない。
    redirect_to order_details_path if conditions_to_get_details_index
  end
end
