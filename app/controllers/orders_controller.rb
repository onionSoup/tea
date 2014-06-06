class OrdersController < ApplicationController

  def index
    @order = Order.new
    25.times { @order.order_details.build }
  end

  def create
    @order = Order.new(order_params)
    redirect_to orders_path unless @order.save
  end

  private
    def order_params
      params.require(:order).permit(:user_id, :time_limit_id, order_details_attributes: [:id, :item_id, :order_id, :quantity ] )
    end
end
