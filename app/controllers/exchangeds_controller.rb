class ExchangedsController < ApplicationController
  def show
    #これで書くと、元のページと動作が変わる。最もビューを書き換えればそれで良いのでこれは選択肢にはいる
    #@orders = Order.includes(:user, order_details: :item).exchanged
    #そのため、今回は@usersを使う。
    @users = User.includes(orders: {order_details: :item}).where('orders.state = ?', Order.states['exchanged']).references(:orders)
  end

  def destroy
    Order.destroy_all state: Order.states['exchanged']
    redirect_to registered_path, :flash => {:success => '商品の削除が完了しました。'}
  end
end
