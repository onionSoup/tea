class OrdersController < ApplicationController
  def new
    redirect_to new_session_path unless signed_in?
    @order = Order.new
    25.times { @order.order_details.build }
    @items = Item.order(:id)
  end

  def create
    @order = Order.new(order_params)
    redirect_to new_order_path unless @order.save
  end

  def edit
    redirect_to new_session_path unless signed_in?
    @order = current_user.order
    redirect_to new_session_path unless @order
    size = @order.order_details.size
    (25 - size).times { @order.order_details.build } if size < 25
    @items = Item.order(:id)
  end

  def update
    @order = current_user.order
    if @order.update_attributes(order_params)
      render :create
    else
      redirect_to edit_order_path
    end
  end

  private

  def order_params
    params.require(:order).permit(:user_id, order_details_attributes: [:id, :item_id, :order_id, :quantity ] )
  end
end
