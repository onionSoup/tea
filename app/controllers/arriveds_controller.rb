class ArrivedsController < ApplicationController
  def show
    @orders = Order.includes(:user, {order_details: :item}).arrived
  end

  def exchange
    return redirect_to action: :show unless params[:order_ids]

    Order.where(id: params[:order_ids]).update_all(state: Order.states[:exchanged])
    flash.now[:success] = '引換したことを登録しました。'
    redirect_to exchanged_path
  end
end
