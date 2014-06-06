class ExchangedsController < ApplicationController
  def show
  end

  def destroy
    Order.destroy_all state: Order.states['exchanged']
    redirect_to registered_path, :flash => {:success => '商品の削除が完了しました。'}
  end
end
