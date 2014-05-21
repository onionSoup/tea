class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def index
    @order = Order.new
    25.times { @order.order_details.build }
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @order = Order.new(order_params)
    if @order.save
    else
      render :new
    end
  end

  def update
    if @order.update(order_params)
      redirect_to @order, notice: 'Order was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_url, notice: 'Order was successfully destroyed.'
  end

  def registered
  end

  def undispatched
    if(params[:orders][:input_complete])
      Order.registered.each do |order|
        order.state = :undispatched
        order.save
      end
      flash[:success] = "ネスレ公式への入力が完了したこと登録しました。"
      redirect_to arrived_orders_path
    end
  end

  def arrived
    if(params[:orders][:undispatched_complete])
      Order.undispatched.each do |order|
        order.state = :arrived
        order.save
      end
      flash[:success] = "ネスレ公式からお茶が届いたことを登録しました。"
      #redirect_to
    end
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:user_id, :time_limit_id, order_details_attributes: [:id, :item_id, :order_id, :quantity ] )
    end
end
