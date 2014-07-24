class OrderDetailsController < ApplicationController
  def index
    @order = User.includes(order: {order_details: :item}).find(current_user).order
    @items = Item.order(:id)
  end

  def create
    @order = current_user.order
    @order_detail = @order.order_details.build(order_detail_params)

    if @order_detail.save
      flash[:success] = "#{@order_detail.item.name}を追加しました。"
    else
      message = @order_detail.errors.messages[:item_id] || @order_detail.errors.messages[:quantity]
      flash[:error] = message.join
    end

    redirect_to order_details_path
  end

  def destroy
    @detail = OrderDetail.find(params[:id])
    OrderDetail.destroy @detail

    redirect_to order_details_path, flash: {success: "#{@detail.item.name}の注文を削除しました。"}
  end

  private

  def order_detail_params
    params.require(:order_detail).permit(:item_id, :quantity)
  end
end
