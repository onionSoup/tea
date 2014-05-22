class OrdersController < ApplicationController
  #before_action :set_order, only: [:show, :edit, :update, :destroy]

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

=begin
  def update
    if @order.update(order_params)
      redirect_to @order, notice: 'Order was successfully updated.'
    else
      render :edit
    end
  end
=end

  def destroy
    @order.destroy
    redirect_to orders_url, notice: 'Order was successfully destroyed.'
  end

  def registered
  end

  def ordered
    order_state_save('ordered', 'ネスレ公式へ注文したことを登録しました。(order complete)')
  end

  def arrived
    order_state_save('arrived', 'ネスレ公式からお茶が届いたことを登録しました。(arrival complete)')
  end

  def exchanged
    order_state_save('exchanged','お茶とお金の引換が完了したことを登録しました。(exchange complete)')
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:user_id, :time_limit_id, order_details_attributes: [:id, :item_id, :order_id, :quantity ] )
    end

    def order_state_save(state_string, flash_message)
      if(params[:order][:state_by_hand] == state_string)
        before_state = Order.before_state(state_string)
        Order.method(before_state).call.each do |order|
          order.state = state_string.to_sym
          order.save
        end
        flash.now[:success] = flash_message
      end
    end
end
