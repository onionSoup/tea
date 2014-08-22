class ArrivedsController < ApplicationController
  def show
    @users = User.includes(order: {order_details: :item})
                 .order_in_state_of('arrived')
                 .has_at_least_one_detail
  end

  def exchange
    exchanged_order_count = Order.where(id: params[:order_ids])
                                 .update_all(state: Order.states[:exchanged])

    if exchanged_order_count.zero?
      redirect_to arrived_path,   flash: {error: 'チェックが入っていません。'}
    else
      redirect_to exchanged_path, flash: {success: '引換したことを登録しました。'}
    end
  end
end
