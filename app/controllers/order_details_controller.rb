class OrderDetailsController < ApplicationController
  before_action :set_order_detail, only: [:show, :edit, :update, :destroy]

  # GET /order_details
  def index
    @order_details = OrderDetail.all
  end

  # GET /order_details/1
  def show
  end

  # GET /order_details/new
  def new
    @order_detail = OrderDetail.new
  end

  # GET /order_details/1/edit
  def edit
  end

  # POST /order_details
  def create
    @order_detail = OrderDetail.new(order_detail_params)
    if @order_detail.save
      redirect_to @order_detail, notice: 'Order detail was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /order_details/1
  def update
    if @order_detail.update(order_detail_params)
      redirect_to @order_detail, notice: 'Order detail was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /order_details/1
  def destroy
    @order_detail.destroy
    redirect_to order_details_url, notice: 'Order detail was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order_detail
      @order_detail = OrderDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_detail_params
      params.require(:order_detail).permit(:order_id, :item_id, :quantity)
    end
end
