class OrderDetailsController < ApplicationController
  include Signin
  before_action :need_signed_in
  before_action :reject_index_since_ordered, only: [:index]

  def index
    @order = User.includes(order: {order_details: :item}).find(current_user).order
    @order_detials = OrderDetail.new
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

  def reject_index_since_ordered
    unless current_user.order.state == 'registered'
      redirect_to order_path, flash: {error: '既に管理者がネスレに発注したため、注文の修正はできません。'}
    end
  end
end
