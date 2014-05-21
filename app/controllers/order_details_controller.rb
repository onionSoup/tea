class OrderDetailsController < ApplicationController
  before_action :set_order_detail, only: [:show, :edit, :update, :destroy]

  def index
    @order_details = OrderDetail.all
  end

  def show
  end

  def new
    @order_detail = OrderDetail.new
  end

  def edit
  end

  def create
    @order_detail = OrderDetail.new(order_detail_params)
    if @order_detail.save
      redirect_to @order_detail, notice: 'Order detail was successfully created.'
    else
      render :new
    end
  end

  def update
    if @order_detail.update(order_detail_params)
      redirect_to @order_detail, notice: 'Order detail was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @order_detail.destroy
    redirect_to order_details_url, notice: 'Order detail was successfully destroyed.'
  end

  private
    def set_order_detail
      @order_detail = OrderDetail.find(params[:id])
    end

    def order_detail_params
      params.require(:order_detail).permit(:order_id, :item_id, :quantity)
    end
end
