class ExchangedsController < ApplicationController
  def show
  end

  def destroy
    Order.destroy_all state: Order.states['exchanged']
    redirect_to registered_path, :success = '引換済みの注文情報を削除しました'
  end
end
