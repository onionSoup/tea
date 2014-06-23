class OrdersController < ApplicationController
  before_action :need_signed_in, only: :new
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
    redirect_to new_session_path unless signed_in?
    @order = current_user.order
    redirect_to new_session_path unless @order
    size = @order.order_details.size
    (Constants::DETAILS_SIZE_OF_FORM - size).times { @order.order_details.build } if size < Constants::DETAILS_SIZE_OF_FORM
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

  def need_signed_in
    redirect_to new_session_path unless signed_in?
  end
end
