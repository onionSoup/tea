class OrdersController < ApplicationController
  def new
    @order = Order.new
    25.times { @order.order_details.build }
    @items = Item.order(:id)
  end

  def create
    @order = Order.new(order_params)
    redirect_to new_order_path unless @order.save
  end

  def edit
    @order = User.find(current_user).order
    @items = Item.order(:id)
  end

  private
    def order_params
      params.require(:order).permit(:user_id, order_details_attributes: [:id, :item_id, :order_id, :quantity ] )
    end
end
