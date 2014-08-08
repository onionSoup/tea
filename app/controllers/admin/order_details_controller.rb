class Admin::OrderDetailsController < ApplicationController
  def index
    @user = User.includes(order: {order_details: :item}).find(params[:user_id])
    @items = Item.order(:id)
    @is_registered = @user.order.state == 'registered'
  end

  def create
    user = User.find(params[:user_id])
    order_detail = user.order.order_details.build(admin_order_detail_params)

    if order_detail.save
      flash[:success] = "#{order_detail.item.name}を追加しました。"
    else
      message = order_detail.errors.messages[:item_id] || order_detail.errors.messages[:quantity]
      flash[:error] = message.join
    end

    redirect_to admin_user_order_details_path(user.id)
  end

  def destroy
    order_detail = OrderDetail.find(params[:id])

    OrderDetail.destroy order_detail

    redirect_to admin_user_order_details_path(order_detail.order.user), flash: {success: "#{order_detail.item.name}を削除しました。"}
  end

  private

  def admin_order_detail_params
    params.require(:order_detail).permit(:item_id, :quantity)
  end
end