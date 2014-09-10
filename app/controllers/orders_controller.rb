class OrdersController < ApplicationController
  include Login
  before_action :need_logged_in

  def show
    @order = User.includes(order: {order_details: :item}).find(current_user).order
    @items = Item.order(:id)
  end

  def update
    @order        = current_user.order
    @order_detail = @order.order_details.create!(order_detail_params)

    redirect_to order_path, flash: {success: "#{@order_detail.item.name}を追加しました。"}
  rescue ActiveRecord::RecordInvalid => e
    @order_detail = e.record

    render :show
  end

  def order_detail_params
    params.require(:order_detail).permit(:item_id, :quantity)
  end
end
