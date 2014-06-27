class OrdersController < ApplicationController
  before_action :need_signed_in, only: [:edit]
  before_action :reject_edit_when_ordered, only: [:edit]

  def edit
    @order = User.includes(order: {order_details: :item}).find(current_user).order
    @items = Item.order(:id)
  end

  def update
    @order = current_user.order

    #update_attributesに渡す。
    attr_for_update_order = {}
    attr_for_update_order[:user_id] = current_user.id
    attr_for_update_order[:order_details_attributes] = details_with_item_and_quantity

    @order.update_attributes(attr_for_update_order)

    #details_with_item_and_quantity.any?のほうがやっていることはわかりやすいかもしれないが、再度関数を呼ぶのは良くないため呼ばない。
    if attr_for_update_order[:order_details_attributes].any? && @order.valid?
      added_item =  Item.find( attr_for_update_order[:order_details_attributes]['0']['item_id'])
      flash[:success] = "#{added_item.name}を追加しました。"
    else
      invalid_error_message = @order.errors[:base].join
      #details_with_item_and_quantityが[]の時（商品名と数量の両方を指定していない時）でも、@orderはvalidである。
      #しかし商品名と数量の両方がなければorder_detailを作れないので、ユーザーに'商品名と数量を両方指定して注文してください'と教える。
      flash[:error] = invalid_error_message.empty? ? '商品名と数量を両方指定して注文してください' : invalid_error_message
    end
    redirect_to edit_order_path
  end

  private

  def order_params
    params.require(:order).permit(:user_id, order_details_attributes: [:id, :item_id, :order_id, :quantity ] )
  end

  #order_paramsが含む、itemやquantityがblankなdetailsを排除する。
  def details_with_item_and_quantity
    order_params[:order_details_attributes].select {|k,v| v[:item_id].present? && v[:quantity].present? }
  end

  def need_signed_in
    redirect_to new_session_path and return unless signed_in?
  end

  def reject_edit_when_ordered
    redirect_to new_session_path,
    flash: {error:'既に管理者がネスレに発注したため、注文の修正はできません。'} and return unless current_user.order.state == 'registered'
  end
end
