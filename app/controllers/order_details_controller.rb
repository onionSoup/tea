class OrderDetailsController < ApplicationController
  def destroy
    #orders/edit.html.erbからしかこのアクションは呼ばれない。
    #order.state != :registeredの時 orders#edit は実行されない
    #そのためここでの条件分岐（order.stateの確認）は、今のところ不要
    @detail = OrderDetail.find(params[:id])
    OrderDetail.destroy @detail

    redirect_to edit_order_path, flash:{success: "#{@detail.item.name}の注文を削除しました。"}
  end
end
