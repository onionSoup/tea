class NestleInputsController < ApplicationController
  def show
  end

  def update
    if(params[:nestle_input][:input_complete])
      Order.registered.each do |order|
        order.state = :shipped
        order.save
      end
      flash[:success] = "ネスレ公式への入力が完了したこと登録しました。"
    end
    redirect_to undispatched_path
  end
end
