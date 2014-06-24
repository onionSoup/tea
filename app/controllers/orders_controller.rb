class OrdersController < ApplicationController
  before_action :need_signed_in, only: [:edit]
  def edit
    @order = current_user.order
    @order.remaining_amount_of_details.times  { @order.order_details.build }
    @items = Item.order(:id)
  end

  def update
    @order = current_user.order
    @order.update_attributes(params_without_blank_details)
    if params_without_blank_details[:order_details_attributes].any? && @order.valid?
      render :create
    else
      flash[:error] = @order.errors[:base].join
      redirect_to edit_order_path
    end
  end

  private

  def order_params
    params.require(:order).permit(:user_id, order_details_attributes: [:id, :item_id, :order_id, :quantity ] )
  end

  def params_without_blank_details
    result_params = {}
    result_params[:order_details_attributes] = order_params[:order_details_attributes].select{|k,v|  v[:item_id].present? && v[:quantity].present? }
    result_params[:user_id] = order_params[:user_id]
    result_params
  end

  def need_signed_in
    redirect_to new_session_path and return unless signed_in?
  end
end
