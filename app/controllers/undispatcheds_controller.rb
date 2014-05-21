class UndispatchedsController < ApplicationController
  def show
  end

  def update
    if(params[:undispatched][:undispatched_complete])
      Order.shipped.each do |order|
        order.state = :arrived
        order.save
      end
      flash[:success] = "ネスレ公式からお茶が届いたことを登録しました。"
    end
    redirect_to trade_path
  end
end
