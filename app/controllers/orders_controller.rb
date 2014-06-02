class OrdersController < ApplicationController
  #before_action :set_order, only: [:show, :edit, :update, :destroy]

  def index
    @order = Order.new
    25.times { @order.order_details.build }
  end

  def create
    @order = order_factory(order_params)
    @order.save
    if @order.order_details.empty?
      redirect_to orders_path
    else
      #createビューを通常通り表示
    end
  end

  def registered
  end

  def ordered
    order_state_save('ordered', 'ネスレ公式へ注文したことを登録しました。')
  end

  def arrived
    order_state_save('arrived', 'ネスレ公式からお茶が届いたことを登録しました。')
  end

  def exchanged
    if(params[:order][:state_by_hand] == 'exchanged')
      checked_user = []
      checked_user_list(checked_user, params)
      map_checked_user_to_user_object(checked_user)
      checked_user.each do |user|
        user.orders.arrived.each do |order|
          if state_convert_to(order, 'exchanged')
            flash.now[:success] = '引換したことを登録しました。'
          end
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

    def checked_user_list(user,params)
      if params[:order][:user_hash]
        params[:order][:user_hash].each do |name, checked|
          if checked == '1'
            user << name
          end
        end
      end
    end

    def map_checked_user_to_user_object(checked_user)
      unless checked_user.empty?
        checked_user.map! do |user|
          user = User.find_by(name: user)
        end
      end
    end

    def state_convert_to(order, after_state)
      if after_state.class == String
        after_state = after_state.to_sym
      end
      order.state = after_state
      order.save
    end

    def order_state_save(state_string, flash_message)
      if(params[:order][:state_by_hand] == state_string)
        before_state = Order.before_state(state_string)
        Order.method(before_state).call.each do |order|
          state_convert_to(order, state_string)
          flash.now[:success] = flash_message
        end
      end
    end

    #order_factory
      #params
        #=>{"user_id"=>"1",
        #   "order_details_attributes"=>
        #   {"0"=>{"item_id"=>"1", "quantity"=>"4"},
        #    "1"=>{"item_id"=>"1", "quantity"=>"0"}...
        #    "24"=>{"item_id"=>"1", "quantity"=>"0"}}}
    def order_factory(params)
      params[:"order_details_attributes"].each do |param|
        if(param.second[:quantity].to_i > 0)
          param.second['then_price'] = Item.find(param.second[:item_id].to_i).price
        end
      end
      Order.new(params)
    end
end
