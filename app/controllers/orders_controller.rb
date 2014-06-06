class OrdersController < ApplicationController

  def index
    @order = Order.new
    25.times { @order.order_details.build }
  end

  def create
    @order = Order.new(order_params)
    if @order.save
    else
      redirect_to orders_path
    end

  end

  def registered
  end

  def ordered
    #これ良くない。getアクションで、副作用（保存）を伴ってはいけない
    # リソースを変えて、getとpost２つに対応させる。orderedな一覧を取るgetとその更新処理をするpostで厳密に分けるべき
    order_state_save('ordered', 'ネスレ公式へ注文したことを登録しました。')
  end

  def arrived
    order_state_save('arrived', 'ネスレからお茶が届いたことを登録しました。')
  end

  def exchanged
    return unless params[:order][:state_by_hand] == 'exchanged'
    checked_user_names = checked_user_names(params)
    checked_users = User.where(name: checked_user_names);
    checked_users.each do |user|
      unless user.orders.update_all(state: Order.state_sym2int(:exchanged))
        #flashをここに書くなら、カウンタ変数はいらない
        updated_flag = true
      end
    flash.now[:success] = '引換したことを登録しました。' if updated_flag
  end
#これのリファクタリングだけど、かえってわかりづらいかも
#        user.orders.arrived.each do |order|
#          if order.update_attributes state: :exchanged
#            flash.now[:success] = '引換したことを登録しました。'
#          end
#       end
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:user_id, :time_limit_id, order_details_attributes: [:id, :item_id, :order_id, :quantity ] )
    end

    def checked_user_names(params)
      return [] unless params[:order][:user_hash]

      params[:order][:user_hash].map {|name, checked| name if checked == '1'}.compact
    end

    def order_state_save(state_string, flash_message)
      return unless params[:order][:state_by_hand] == state_string


      before_state = Order.before_state(state_string)
      #（）を付けないと意図通りに動かない
      unless( (Order.send(before_state).update_all state: Order.state_sym2int(state_string) ) == 0 )
        updated_flag = true
      end
      flash.now[:success] = flash_message if updated_flag


      #最初教えて頂いたのはOrder.where(state: before_state).update_all state: state_string.to_sym
      #where(state: before_state) でinvalid input syntax for integerになったので書きなおした。

      #flashはピンと来ないそうだ 上手く説明ができないとのこと
    end
end
