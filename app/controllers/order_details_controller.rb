class OrderDetailsController < ApplicationController
  include Login
  include PeriodHelper

  before_action :need_logged_in
  before_action :period_must_have_defined_times,      only: [:index]
  before_action :to_order_show_if_not_registered,     only: [:index]
  before_action :to_order_show_if_out_of_date_period, only: [:index]

  def index
    @order = User.find(current_user).order
    @items = Item.order(:id)
  end

  def create
    @order        = current_user.order
    @order_detail = @order.order_details.create!(order_detail_params)

    redirect_to order_details_path, flash: {success: "#{@order_detail.item.name}を追加しました。"}
  rescue ActiveRecord::RecordInvalid => e
    @order_detail = e.record

    render :index
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

  def to_order_show_if_not_registered
    if current_user.order.not_registered?
      redirect_to order_path, flash: {error: '既に管理者がネスレに発注したため、注文の作成・変更はできません。'}
    end
  end

  def to_order_show_if_out_of_date_period
    unless Period.include_now?
      redirect_to order_path, flash: {error: '注文期限を過ぎているため、注文の作成・変更はできません。'}
    end
  end
end
