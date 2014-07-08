class OrderDetailsController < ApplicationController
  def destroy
    @detail = OrderDetail.find(params[:id])
    OrderDetail.destroy @detail

    redirect_to edit_order_path, flash: {success: "#{@detail.item.name}の注文を削除しました。"}
  end
end
