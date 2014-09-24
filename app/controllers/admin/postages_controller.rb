class Admin::PostagesController < ApplicationController
  include Login
  before_action :need_logged_in

  def show
    @postage = Postage.take!
    @cost = @postage.cost
    @border = @postage.border
  end

  def update
    @postage = Postage.take!
    @cost = @postage.cost
    @border = @postage.border
    @postage.update_attributes! postage_params

    redirect_to :admin_postage, flash: {success: "送料を#{@postage.cost}円 送料無料条件を#{@postage.border}円に設定しました。"}
  rescue ActiveRecord::RecordInvalid => e
    @postage  = e.record
    render :show
  end

  def postage_params
    params.require(:postage).permit(:cost, :border)
  end
end
