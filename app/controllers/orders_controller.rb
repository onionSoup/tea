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
    params = add_then_price(order_params)
    @order = Order.new(params)
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

  def ordered
    order_state_save('ordered', 'ネスレ公式へ注文したことを登録しました。(order complete)')
  end

  def arrived
    order_state_save('arrived', 'ネスレ公式からお茶が届いたことを登録しました。(arrival complete)')
  end

  def exchanged
#params
#=>{"order"=>
#    {"user_hash"=>{"user1"=>"0", "user2"=>"1"}
    if(params[:order][:state_by_hand] == 'exchanged' )
      checked_user =[]
      params[:order][:user_hash].each do |name, checked|
        if checked == "1"
          checked_user << name
        end
      end
      if checked_user
        checked_user.map! do |user|
          user = User.find_by(name: user)
        end
      end
      checked_user.each do |user|
        user.orders.arrived.each do |order|
          order.state = :exchanged
          order.save
        end
      end
    end
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

    def add_then_price(params)
      params[:"order_details_attributes"].each do |param|
        if (  param.second[:quantity].to_i > 0 )
          param.second["then_price"] = Item.find(param.second[:item_id].to_i).price
        end
      end
      params
    end
end
