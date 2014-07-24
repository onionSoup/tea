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
      #error message
    end
    redirect_to new_order_detail_path
=begin
    attr_for_update_order = {}
    attr_for_update_order[:user_id] = current_user.id
    attr_for_update_order[:order_details_attributes] = details_with_item_and_quantity

    @order.update_attributes(attr_for_update_order)

    if attr_for_update_order[:order_details_attributes].present? && @order.valid?
      added_item = Item.find(attr_for_update_order[:order_details_attributes]['0']['item_id'])
      flash[:success] = "#{added_item.name}を追加しました。"
    else
      invalid_error_message = @order.errors[:base].join
      flash[:error] = invalid_error_message.empty? ? '商品名と数量を両方指定して注文してください' : invalid_error_message
    end

    redirect_to new_order_detail_path
=end


  end

  def destroy
    @detail = OrderDetail.find(params[:id])
    OrderDetail.destroy @detail

    redirect_to edit_order_path, flash: {success: "#{@detail.item.name}の注文を削除しました。"}
  end

  private

  def order_detail_params
    params.require(:order_detail).permit(:item_id, :quantity)
  end

  def details_with_item_and_quantity
    order_params[:order_details_attributes].select {|k, v| v[:item_id].present? && v[:quantity].present? }
  end
end
