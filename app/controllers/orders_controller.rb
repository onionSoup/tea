class OrdersController < ApplicationController
  before_action :need_signed_in, :guide_to_appropriate_form, only: [:new, :edit]
  DETAILS_SIZE_OF_FORM = 25

  def edit
    @order = current_user.order
    size = @order.order_details.size
    (DETAILS_SIZE_OF_FORM - size).times { @order.order_details.build } if size < DETAILS_SIZE_OF_FORM
    @items = Item.order(:id)
  end

  def update
    @order = current_user.order
    @order.update_attributes(params_without_blank_details)
    if params_without_blank_details[:order_details_attributes].any?
      render :create
    else
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

  def guide_to_appropriate_form
    appropriate_path = current_user.order ? edit_order_path : new_order_path
    redirect_to appropriate_path and return if request.path_info != appropriate_path
  end
end
