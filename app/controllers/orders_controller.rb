class OrdersController < ApplicationController
  before_action :need_signed_in
  before_action :reject_edit_when_ordered, only: [:edit]
  before_action :reject_show_until_ordered, only: [:show]

  def show
    @order = User.includes(order: {order_details: :item}).find(current_user).order
  end

  def edit
    @order = User.includes(order: {order_details: :item}).find(current_user).order
    @items = Item.order(:id)
  end

  def update
    @order = current_user.order

    attr_for_update_order = {}
    attr_for_update_order[:user_id] = current_user.id
    attr_for_update_order[:order_details_attributes] = details_with_item_and_quantity

    @order.update_attributes(attr_for_update_order)

    if attr_for_update_order[:order_details_attributes].any? && @order.valid?
      added_item = Item.find(attr_for_update_order[:order_details_attributes]['0']['item_id'])
      flash[:success] = "#{added_item.name}を追加しました。"
    else
      invalid_error_message = @order.errors[:base].join
      flash[:error] = invalid_error_message.empty? ? '商品名と数量を両方指定して注文してください' : invalid_error_message
    end
    redirect_to edit_order_path
  end

  private

  def order_params
    params.require(:order).permit(:user_id, order_details_attributes: [:id, :item_id, :order_id, :quantity])
  end

  def details_with_item_and_quantity
    order_params[:order_details_attributes].select {|k, v| v[:item_id].present? && v[:quantity].present? }
  end

  def need_signed_in
    redirect_to new_session_path unless signed_in?
  end

  def reject_edit_when_ordered
    unless current_user.order.state == 'registered'
      redirect_to order_path, flash: {error: '既に管理者がネスレに発注したため、注文の修正はできません。'}
    end
  end

  def reject_show_until_ordered
    #showでできることはeditですべてできるので、エラーメッセージを出さない。
    redirect_to edit_order_path if current_user.order.state == 'registered'
  end
end
