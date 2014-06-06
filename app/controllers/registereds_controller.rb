class RegisteredsController < ApplicationController
  def show
    @registereds = Order.name_price_quantity_sum(:registered)
  end

  def order
    unless( (Order.registered.update_all state: Order.states["ordered"] ) == 0 )
      updated_flag = true
    end
    flash.now[:success] = 'ネスレ公式へ注文したことを登録しました。' if updated_flag
    redirect_to ordered_path
  end
end
