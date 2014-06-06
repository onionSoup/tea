class ArrivedsController < ApplicationController
  def show
  end

  def exchange
    checked_user_names = checked_user_names(params)
    checked_users = User.where(name: checked_user_names);
    checked_users.each do |user|
      unless user.orders.update_all(state: Order.states["exchanged"])
        #flashをここに書くなら、カウンタ変数はいらない
        updated_flag = true
      end
    flash.now[:success] = '引換したことを登録しました。' if updated_flag
    end
    redirect_to exchanged_path
  end

  private
    def checked_user_names(params)
      return [] unless params[:order][:user_hash]

      params[:order][:user_hash].map {|name, checked| name if checked == '1'}.compact
    end
end
