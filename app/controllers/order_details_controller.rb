class OrderDetailsController < ApplicationController
  include Login
  before_action :need_logged_in

  def create
    @order        = current_user.order
    @order_detail = @order.order_details.create!(order_detail_params)

    redirect_to order_path, flash: {success: "#{@order_detail.item.name}を追加しました。"}
  rescue ActiveRecord::RecordInvalid => e
    @order_detail = e.record

    redirect_to order_path  #TODO @order_detailをわたす
    #render '/orders/show'  これでorder_details/indexにURLがなってしまうので。
    #render 'orders/show'
  end

  def destroy
    @detail = OrderDetail.find(params[:id])
    OrderDetail.destroy @detail

    redirect_to order_path, flash: {success: "#{@detail.item.name}の注文を削除しました。"}
  end

  private

  def order_detail_params
    params.require(:order_detail).permit(:item_id, :quantity)
  end
end
